//
//  TorrentManager.swift
//  Magnetizer
//
//  Created by Nicolas Sanguinetti on 8/24/14.
//  Copyright (c) 2014 Nicolas Sanguinetti. All rights reserved.
//

import Foundation

class TorrentManager {
    private var transmissionHost: NSURL

    init (_ transmissionHost: NSURL) {
        self.transmissionHost = transmissionHost
    }

    func addTorrent(magnetURL: NSURL) {
        NSLog(transmissionHost.description)
        NSLog(magnetURL.description)
    }
}