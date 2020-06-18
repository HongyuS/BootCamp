//
//  Global.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/14.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Network

let device_ip_address: NWEndpoint.Host = "192.168.10.1"
let device_ip_port: NWEndpoint.Port = 8889
let local_ip_port_state: NWEndpoint.Port = 8890
let local_ip_port_video: NWEndpoint.Port = 11111

// Extract specific state info by key.  Refer to tello spec for list of keys.
func extractInfo(byKey key: String, with items: [Substring]) -> String? {
    if let item = items.first(where: { $0.hasPrefix(key) }) {
        let pair = item.split(separator: ":")
        if pair.count == 2, let value = pair.last {
            return String(value)
        }
    }
    return nil
}

// Execute a closure after a given delay in seconds.
func delay(_ delay: Double, action: @escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: action)
}
