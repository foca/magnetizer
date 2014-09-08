//
//  AppDelegate.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/23/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let torrents: TorrentManager

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var prefWindow: NSWindow!

    let statusBar = NSStatusBar.systemStatusBar()
    var statusItem: NSStatusItem?

    override init() {
        // Set up default values for the user preferences
        let prefsFile = NSBundle.mainBundle().pathForResource("DefaultPrefs", ofType: "plist")!
        let defaultPreferences = NSDictionary(contentsOfFile: prefsFile)
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultPreferences)

        self.torrents = TorrentManager()

        super.init()
    }

    override func awakeFromNib() {
        statusItem = statusBar.statusItemWithLength(-1)
        if let item = statusItem {
            item.menu = menu
            item.highlightMode = true
            item.image = NSImage(named: "magnet")
            item.alternateImage = NSImage(named: "magnet-alt")
        }
    }

    func validateUserInterfaceItem(anItem: NSValidatedUserInterfaceItem!) -> Bool {
        if anItem.action() == "openRemoteGUI:" {
            return torrents.available()
        }
        return true
    }

    @IBAction func openRemoteGUI(AnyObject) {
        if let hostURL = self.torrents.guiURL() {
            NSWorkspace.sharedWorkspace().openURL(hostURL)
        }
    }

    @IBAction func openPrefDialog(AnyObject) {
        prefWindow.makeKeyAndOrderFront(self)
        NSApp.activateIgnoringOtherApps(true)
    }

    @IBAction func quitApplication(AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }

    func applicationWillFinishLaunching(notification: NSNotification!) {
        // Register ourselves to handle URL open events
        let eventManager = NSAppleEventManager.sharedAppleEventManager()
        eventManager.setEventHandler(self,
            andSelector: "handleURLEvent:withReplyEvent:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func handleURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        let url = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!
        self.torrents.add(url)
    }
}
