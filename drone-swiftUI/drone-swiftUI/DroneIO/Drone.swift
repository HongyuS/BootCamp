//
//  Drone.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Modified by Hongyu Shi on 2020/6/16
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation
import Network

class Drone {
    
    var networkHandler: DeviceInterface?
    
    public var isIdle: Bool = false
    
    var battery: Int?
    var height: String?
    var time: String?
    var connectionStatus: String?
    var droneStatus: String?
    
    public var streamBuffer = Array<UInt8>()
    
    var host_ip: NWEndpoint.Host!
    var host_port: NWEndpoint.Port!
    var local_port: NWEndpoint.Port!
    var local_video_port: NWEndpoint.Port!
    
    required init(host: NWEndpoint.Host, port: NWEndpoint.Port, port_local: NWEndpoint.Port, port_video: NWEndpoint.Port) {
        self.host_ip = host
        self.host_port = port
        self.local_port = port_local
        self.local_video_port = port_video
    }
    
    func processStateData(with items: [Substring]) {
        if let value = extractInfo(byKey: "bat", with: items) {
            DispatchQueue.main.async {
                self.battery = Int(value) ?? 0
            }
        }
        if let value = extractInfo(byKey: "h", with: items) {
            DispatchQueue.main.async {
                self.height = value
            }
        }
        if let value = extractInfo(byKey: "time", with: items) {
            DispatchQueue.main.async {
                self.time = value
            }
        }
    }
    
    func processDeviceData(with items: [Substring]) {
        let speedx = Int(extractInfo(byKey: "vgx:", with: items) ?? "0") ?? 0
        let speedy = Int(extractInfo(byKey: "vgy:", with: items) ?? "0") ?? 0
        let speedz = Int(extractInfo(byKey: "vgz:", with: items) ?? "0") ?? 0
        print(#function, speedx, speedy, speedz)
        self.isIdle = (speedx + speedy + speedz) == 0
        if self.isIdle {
            self.droneIsIdling()
        }
    }
    
}

// MARK: - Drone Delegate

extension Drone: DroneDelegate {
    
    // Status string from device
    func onStatusDataArrival(with items: [Substring]) {
        processStateData(with: items)
        processDeviceData(with: items)
    }
    
    func onVideoDataArrival(with data: Data) {
        print(#function)
        DispatchQueue.main.async {
            if data.count < 1460 && self.streamBuffer.count > 40 {
                // Write stream buffer
                let packet = [UInt8](data)
                self.streamBuffer.append(contentsOf: packet)
            }
        }
    }
    
    func onConnectionStatusUpdate(msg: String) {
        DispatchQueue.main.async {
            self.connectionStatus = msg
        }
    }
    
    func onListenerStatusUpdate(msg: String) {
        print("onListenerStatusUpdate: \(msg)")
    }
    
    func onDroneStatusUpdate(msg: String) {
        DispatchQueue.main.async {
            self.droneStatus = msg
        }
    }
    
    func droneIsIdling() {
        DispatchQueue.main.async {
            self.droneStatus = "Idle"
        }
    }
}
