//
//  AppDelegate.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/23/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!

    let statusBar = NSStatusBar.systemStatusBar()
    var statusItem: NSStatusItem?

    func applicationWillFinishLaunching(notification: NSNotification!) {
        let eventManager = NSAppleEventManager.sharedAppleEventManager()
        eventManager.setEventHandler(self,
            andSelector: "handleURLEvent:withReplyEvent:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
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

    func handleURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        let url = NSURL.URLWithString(event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!)
        NSLog(url.description)
    }

    @IBAction func quitApplication(AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
}
