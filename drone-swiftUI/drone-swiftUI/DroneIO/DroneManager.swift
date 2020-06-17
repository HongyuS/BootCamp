//
//  DroneManager.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation

class DroneManager: DroneInterface {
    
    var drone: DeviceInterface?
    
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
        Global.delay(1.0) {
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
        Global.delay(1.0) {
            if self.isIdle() {
                self.drone?.sendCommand(cmd: "streamoff")
            } else {
                Global.delay(1.0) {
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
