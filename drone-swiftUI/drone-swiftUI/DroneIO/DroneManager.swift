//
//  DroneManager.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation

class DroneManager: ObservableObject {
    
    // Model
    var drone: DeviceInterface?
    @Published var droneData = DroneData()
    
    init(drone: () -> Drone) {
        self.drone = drone()
        self.drone?.delegate = self
    }
    
    func processStateData(with items: [Substring]) {
        if let value = extractInfo(byKey: "bat", with: items) {
            DispatchQueue.main.async {
                self.droneData.battery = Int(value) ?? 0
            }
        }
        if let value = extractInfo(byKey: "h", with: items) {
            DispatchQueue.main.async {
                self.droneData.height = value
            }
        }
        if let value = extractInfo(byKey: "time", with: items) {
            DispatchQueue.main.async {
                self.droneData.time = value
            }
        }
    }
    
    func processDeviceData(with items: [Substring]) {
        let speedx = Int(extractInfo(byKey: "vgx:", with: items) ?? "0") ?? 0
        let speedy = Int(extractInfo(byKey: "vgy:", with: items) ?? "0") ?? 0
        let speedz = Int(extractInfo(byKey: "vgz:", with: items) ?? "0") ?? 0
        print(#function, speedx, speedy, speedz)
        self.droneData.isIdle = (speedx + speedy + speedz) == 0
        if self.droneData.isIdle {
            self.droneIsIdling()
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
    func onStatusDataArrival(with items: [Substring]) {
        processStateData(with: items)
        processDeviceData(with: items)
    }
    
    func onVideoDataArrival(with data: Data) {
        print(#function)
        DispatchQueue.main.async {
            self.droneData.videoFrame?.append(data)
            if data.count < 1460 && self.droneData.videoFrame?.count ?? 0 > 40 {
                // TODO: decode video frame
            }
        }
    }
    
    func onConnectionStatusUpdate(msg: String) {
        DispatchQueue.main.async {
            self.droneData.connectionStatus = msg
        }
    }
    
    func onListenerStatusUpdate(msg: String) {
        print("onListenerStatusUpdate: \(msg)")
    }
    
    func onDroneStatusUpdate(msg: String) {
        DispatchQueue.main.async {
            self.droneData.droneStatus = msg
        }
    }
    
    func droneIsIdling() {
        DispatchQueue.main.async {
            self.droneData.droneStatus = "Idle"
        }
    }
}
