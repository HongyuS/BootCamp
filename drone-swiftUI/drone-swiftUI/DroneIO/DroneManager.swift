//
//  DroneManager.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation

class DroneManager {
    
    // Model
    var drone: DeviceInterface?
    
    var battery: Int?
    var height: String?
    var time: String?
    var connectionStatus: String?
    var droneStatus: String?
    
    init(drone: () -> Drone) {
        self.drone = drone()
    }
    
    func processStateData(withItems items: [Substring]) {
        if let value = extractInfo(byKey: "bat", withItems: items) {
            DispatchQueue.main.async {
                self.battery = Int(value) ?? 0
            }
        }
        if let value = extractInfo(byKey: "h", withItems: items) {
            DispatchQueue.main.async {
                self.height = value
            }
        }
        if let value = extractInfo(byKey: "time", withItems: items) {
            DispatchQueue.main.async {
                self.time = value
            }
        }
    }
}

// MARK: - Drone Interface

extension DroneManager: DroneInterface {
    
    func move(inDirection dir: MoveDirection, withDistance dist: String) {
        print("\(dir) \(dist)")
        self.drone?.sendCommand(cmd: dir.rawValue, arg: dist)
    }
    
    func rotate(inDirection dir: RotateDirection, withDegree deg: String) {
        print("\(dir) \(deg)")
        self.drone?.sendCommand(cmd: dir.rawValue, arg: deg)
    }
    
    func flip(inDirection dir: FlipDirection) {
        print("flip \(dir.rawValue)")
        self.drone?.sendCommand(cmd: "flip", arg: dir.rawValue)
    }
    
    func start() {
        print(#function)
        self.drone?.startConnection()
        delay(1.0) {
            self.drone?.sendCommand(cmd: "streamon")
        }
    }
    
    func stop() {
        print(#function)
        self.landing()
        self.drone?.stopConnection()
    }
    
    func takeoff() {
        print(#function)
        self.drone?.sendCommand(cmd: "takeoff")
    }
    
    func landing() {
        print(#function)
        self.drone?.sendCommand(cmd: "land")
        delay(1.0) {
            if self.isIdle() {
                self.drone?.sendCommand(cmd: "streamoff")
            } else {
                delay(1.0) {
                    self.drone?.sendCommand(cmd: "streamoff")
                }
            }
        }
    }
    
    func renameWifi(ssid: String, pass: String) {
        print(#function, ssid, pass)
        self.drone?.sendCommand(cmd: "wifi \(ssid) \(pass)")
    }
    
    func isIdle() -> Bool {
        print(#function)
        return self.drone?.isIdle ?? false
    }
    
}

// MARK: - Drone Delegate

extension DroneManager: DroneDelegate {
    
    // Status string from device
    func onStatusDataArrival(withItems items: [Substring]) {
        self.processStateData(withItems: items)
    }
    
    func onVideoDataArrival() {
        print("TODO:", #function)
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
