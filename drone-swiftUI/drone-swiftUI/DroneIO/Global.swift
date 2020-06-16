//
//  Global.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/14.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import UIKit
import Network

let device_ip_address: NWEndpoint.Host = "192.168.10.1"
let device_ip_port: NWEndpoint.Port = 8889
let local_ip_port_state: NWEndpoint.Port = 8890
let local_ip_port_video: NWEndpoint.Port = 11111

// Static global class
class Global {
    
    // Extract specific state info by key.  Refer to tello spec for list of keys.
    class func extractInfo(byKey key: String, withItems items: [Substring]) -> String? {
        if let item = items.first(where: { $0.hasPrefix(key) }) {
            let pair = item.split(separator: ":")
            if pair.count == 2, let value = pair.last {
                return String(value)
            }
        }
        return nil
    }
    
    // Drone device factory
    // Command line arguments can be added via "Edit Scheme"
    // Click "Help" and type "Scheme" in Search you will find "Edit Scheme"
    // Under "arguments", section "arguments passed on launch", click "+"
    /*class func createDrone() -> DeviceInterface {
        
        if CommandLine.arguments.contains("-droneDummy") {
            return DroneDummy(host: device_ip_address, port: device_ip_port, port_local: local_ip_port_state)
        } else {
            return Drone(host: device_ip_address, port: device_ip_port, port_local: local_ip_port_state)
        }
        
    }*/
    
    // Execute a closure after a given delay in seconds.
    class func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
