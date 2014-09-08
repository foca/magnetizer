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

    private var authorizationHeader: String {
        if username == nil || password == nil {
            return ""
        }

        let auth = "\(username!):\(password!)".dataUsingEncoding(NSUTF8StringEncoding)
        let base64 = auth!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        return "Basic \(base64)"
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

    private var sessionId: String?

    init() {}

    // Checks whether the service is available or not by ensuring that we have
    // defined a host for the RPC calls.
    func available() -> Bool {
        return host != nil
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
    func add(magnetURL: String) {
        if !available() {
            return
        }

        request("session-get") { (data, response, error) in
            let headers = response.allHeaderFields as Dictionary<String, String>
            self.sessionId = headers["X-Transmission-Session-Id"]

            self.request("torrent-add", arguments: ["filename": magnetURL]) { (data, response, error) in
                NSLog(response.description)
            }
        }
    }

    private func request(method: String, arguments: NSDictionary, handler: (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> ()) {
        let req = createRequest(method, arguments: arguments)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, response, error) in
            handler(data: data, response: response as NSHTTPURLResponse, error: error)
        }
        task.resume()
    }

    // Sugar for requests without any arguments
    private func request(method: String, handler: (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> ()) {
        request(method, arguments: NSDictionary(), handler: handler)
    }

    private func createRequest(method: String, arguments: NSDictionary) -> NSMutableURLRequest {
        let body = ["method": method, "arguments": arguments]
        var req = NSMutableURLRequest(URL: host)

        req.HTTPMethod = "POST"

        req.setValue("Magnetizer v1.0", forHTTPHeaderField: "User-Agent")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        if let sid = sessionId {
            req.setValue(sid, forHTTPHeaderField: "X-Transmission-Session-Id")
        }

        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(body,
            options: NSJSONWritingOptions(0),
            error: NSErrorPointer()
        )

        return req
    }
}
