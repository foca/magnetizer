//
//  TorrentManager.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/24/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Foundation

class TorrentManager {
    private var hostname: String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("TransmissionHost")
    }
    private var rpcPath:  String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("TransmissionRPCPath")
    }
    private var username: String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("TransmissionUsername")
    }
    private var password: String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("TransmissionPassword")
    }

    private var host: NSURL? {
        if let host = hostname {
            var url = NSURL.URLWithString(host)
            if let path = rpcPath {
                return url.URLByAppendingPathComponent(path)
            }
        }
        return nil
    }

    // Checks whether the service is available or not by ensuring that we have
    // defined a host for the RPC calls.
    func available() -> Bool {
        if let url = host {
            return true
        } else {
            return false
        }
    }

    // Returns the URL of the web GUI, if available.
    func guiURL() -> NSURL? {
        if let url = hostname {
            return NSURL.URLWithString(url);
        }
        return nil
    }

    // Adds a new torrent to the remote Transmission daemon, if the service is
    // available.
    func add(magnetURL: NSURL) {
        if available() {
            NSLog(host!.description)
            NSLog(magnetURL.description)
            NSLog("%@, %@", username!, password!)
        }
    }
}
