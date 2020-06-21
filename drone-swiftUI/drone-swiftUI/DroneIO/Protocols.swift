//
//  Protocols.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation
import Network

protocol DroneDelegate {
    
    var networkHandler: DeviceInterface { get set }
    
    func onStatusDataArrival(with items: [Substring])
    
    func onVideoDataArrival(with data: Data)
    
    func onConnectionStatusUpdate(msg: String)
    
    func onListenerStatusUpdate(msg: String)
    
    func onDroneStatusUpdate(msg: String)
    
    func droneIsIdling()
}

protocol DeviceInterface {
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port, port_local: NWEndpoint.Port, port_video: NWEndpoint.Port)
    
    var delegate: DroneDelegate? { get set }
    
    func sendCommand(cmd: String)
    
    func sendCommand(cmd: String, arg: String)
    
    func startConnection()
    
    func stopConnection()
    
}

protocol DroneInterface {
    
    var drone: Drone { get set }
    
    func move(inDirection dir: MoveDirection, withDistance dist: String)
    
    func rotate(inDirection dir: RotateDirection, withDegree deg: String)
    
    func flip(inDirection dir: FlipDirection)
    
    func start()
    
    func stop()
    
    func takeoff()
    
    func landing()
    
    func isIdle() -> Bool
}
