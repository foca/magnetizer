//
//  TorrentManager.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/24/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Foundation

class TorrentManager {
    private let host: NSURL
    private let username: String?
    private let password: String?

    init(host: NSURL, rpcPath: String, username: String?, password: String?) {
        self.host = host.URLByAppendingPathComponent(rpcPath)
        self.username = username
        self.password = password
    }

    convenience init() {
        let preferences = NSUserDefaults.standardUserDefaults()
        self.init(
            host: NSURL.URLWithString(preferences.stringForKey("TransmissionHost")!),
            rpcPath: preferences.stringForKey("TransmissionRPCPath")!,
            username: preferences.stringForKey("TransmissionUsername"),
            password: preferences.stringForKey("TransmissionPassword")
        )
    }

    func addTorrent(magnetURL: NSURL) {
        NSLog(host.description)
        NSLog(magnetURL.description)
        NSLog("%@, %@", username!, password!)
    }
}