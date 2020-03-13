//
//  Global.swift
//  drone
//
//  Created by Kinley Lam (SSE) on 2019/6/14.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import UIKit
import Network

let device_ip_address: NWEndpoint.Host = "192.168.10.1"
let device_ip_port: NWEndpoint.Port = 8889
let local_ip_port_state: NWEndpoint.Port = 8890
let local_ip_video_port: NWEndpoint.Port = 11111

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
    
    // Animate scaling of a button
    class func animateButton(_ button: UIButton, withScaleFactor factor: CGFloat = 0.95, forDuration duration: CGFloat = 0.1 ) {
        guard factor > 0 && factor < 2 else { return }
        guard duration > 0 && duration < 2 else { return }
        let duration = TimeInterval(duration)
        
        UIView.animate(withDuration: duration,
                       animations: { button.transform = CGAffineTransform(scaleX: factor, y: factor) },
                       completion: { _ in UIView.animate(withDuration: duration) { button.transform = CGAffineTransform.identity } }
        )
    }
    
    
    // Update a label control with given value.
    class func updateLabel(_ label: UILabel, withValue value: String) {
        DispatchQueue.main.async {
            label.text = value
        }
    }
    
    // Update a progress bar with given value
    class func updateProgress(_ progressBar: UIProgressView, withValue value: String) {
        if let level = Float(value) {
            DispatchQueue.main.async {
                let pct = level/100.0
                progressBar.setProgress(pct, animated: true)
            }
        }
    }
    
    // Drone device factory
    // Command line arguments can be added via "Edit Scheme"
    // Click "Help" and type "Scheme" in Search you will find "Edit Scheme"
    // Under "arguments", section "arguments passed on launch", click "+"
    class func createDrone() -> DeviceInterface {
        
        if CommandLine.arguments.contains("-droneDummy") {
            return DroneDummy(host: device_ip_address, port: device_ip_port, port_local: local_ip_port_state, video_port: local_ip_video_port)
        } else {
            return Drone(host: device_ip_address, port: device_ip_port, port_local: local_ip_port_state, video_port: local_ip_video_port)
        }
        
    }
    
    // Execute a closure after a given delay in seconds.
    class func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
