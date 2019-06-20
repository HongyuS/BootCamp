//
//  DroneDummy.swift
//  drone
//
//  Created by Kinley Lam (SSE) on 2019/6/14.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation
import Network

class DroneDummy {
    public var delegate: DroneDelegate?
    public var isIdle: Bool = false
    
    required init(host: NWEndpoint.Host, port: NWEndpoint.Port, port_local: NWEndpoint.Port) {
        print(#function)
    }
}

extension DroneDummy: DeviceInterface {
    
    func sendCommand(cmd: String) {
        self.sendCommand(cmd: cmd, arg: "")
    }
    
    func sendCommand(cmd: String, arg: String) {
        self.delegate?.onDroneStatusUpdate(msg: "ok")
    }
    
    func startConnection() {
        self.delegate?.onConnectionStatusUpdate(msg: "ready")
        self.delegate?.onListenerStatusUpdate(msg: "ready")
    }
    
    func stopConnection() {
        self.delegate?.onConnectionStatusUpdate(msg: "stop")
    }
    
}
