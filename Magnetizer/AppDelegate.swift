//
//  AppDelegate.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/23/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let transmissionURL = NSURL.URLWithString("http://transmission.local/")
    var torrentManager: TorrentManager {
        return TorrentManager(transmissionURL)
    }

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var prefWindow: NSWindow!

    let statusBar = NSStatusBar.systemStatusBar()
    var statusItem: NSStatusItem?

    override func awakeFromNib() {
        statusItem = statusBar.statusItemWithLength(-1)
        if let item = statusItem {
            item.menu = menu
            item.highlightMode = true
            item.image = NSImage(named: "magnet")
            item.alternateImage = NSImage(named: "magnet-alt")
        }
    }

    @IBAction func openRemoteGUI(AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(transmissionURL)
    }

    @IBAction func openPrefDialog(AnyObject) {
        prefWindow.makeKeyAndOrderFront(self)
        NSApp.activateIgnoringOtherApps(true)
    }

    @IBAction func quitApplication(AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }

    func applicationWillFinishLaunching(notification: NSNotification!) {
        let eventManager = NSAppleEventManager.sharedAppleEventManager()
        eventManager.setEventHandler(self,
            andSelector: "handleURLEvent:withReplyEvent:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func handleURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        let url = NSURL.URLWithString(
            event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!
        )
        torrentManager.addTorrent(url)
    }
}
