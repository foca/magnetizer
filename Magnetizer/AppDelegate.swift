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
    
    override func awakeFromNib() {
        statusItem = statusBar.statusItemWithLength(-1)
        if let item = statusItem {
            item.menu = menu
            item.highlightMode = true
            item.image = NSImage(named: "magnet")
            item.alternateImage = NSImage(named: "magnet-alt")
        }
    }
    
    @IBAction func itemClicked(AnyObject) {
        NSLog("Item clicked!")
    }
}
