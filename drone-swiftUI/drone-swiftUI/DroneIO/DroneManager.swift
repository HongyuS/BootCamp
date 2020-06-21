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
    @Published var drone: Drone
    
    static var tello = DroneManager {
        Drone.tello
    }
    
    static var preview = DroneManager {
        Drone.preview
    }
    
    init(drone: () -> Drone) {
        self.drone = drone()
    }
    
}

// MARK: - Drone Interface

extension DroneManager: DroneInterface {
    
    func move(inDirection dir: MoveDirection, withDistance dist: String) {
        print("\(dir) \(dist)")
        self.drone.networkHandler.sendCommand(cmd: dir.rawValue, arg: dist)
    }
    
    func rotate(inDirection dir: RotateDirection, withDegree deg: String) {
        print("\(dir) \(deg)")
        self.drone.networkHandler.sendCommand(cmd: dir.rawValue, arg: deg)
    }
    
    func flip(inDirection dir: FlipDirection) {
        print("flip \(dir.rawValue)")
        self.drone.networkHandler.sendCommand(cmd: "flip", arg: dir.rawValue)
    }
    
    func start() {
        print(#function)
        self.drone.networkHandler.startConnection()
    }
    
    func stop() {
        print(#function)
        self.landing()
        self.drone.networkHandler.stopConnection()
    }
    
    func takeoff() {
        print(#function)
        self.drone.networkHandler.sendCommand(cmd: "takeoff")
        delay(1.0) {
            self.drone.networkHandler.sendCommand(cmd: "streamon")
        }
    }
    
    func landing() {
        print(#function)
        self.drone.networkHandler.sendCommand(cmd: "land")
        delay(1.0) {
            if self.isIdle() {
                self.drone.networkHandler.sendCommand(cmd: "streamoff")
            } else {
                delay(1.0) {
                    self.drone.networkHandler.sendCommand(cmd: "streamoff")
                }
            }
        }
    }
    
    func renameWifi(ssid: String, pass: String) {
        print(#function, ssid, pass)
        self.drone.networkHandler.sendCommand(cmd: "wifi \(ssid) \(pass)")
    }
    
    func isIdle() -> Bool {
        print(#function)
        return self.drone.isIdle 
    }
    
}
