//
//  Drone.swift
//  drone
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation
import Network

class Drone {
    
    public var delegate: DroneDelegate?
    
    public var isIdle: Bool = false
    
    private var host_ip: NWEndpoint.Host!
    private var host_port: NWEndpoint.Port!
    private var local_port: NWEndpoint.Port!
    
    private var udpConnection: NWConnection?
    private var udpListener: NWListener?
    private var queue_listener_state: DispatchQueue?
    
    private var stateConnection: NWConnection?
    
    required init(host: NWEndpoint.Host, port: NWEndpoint.Port, port_local: NWEndpoint.Port) {
        self.host_ip = host
        self.host_port = port
        self.local_port = port_local
    }
}


extension Drone: DeviceInterface {
    
    func sendCommand(cmd: String) {
        sendCommand(cmd: cmd, arg: "")
    }
    
    func sendCommand(cmd: String, arg: String){
        
        guard let conn = self.udpConnection, conn.state == .ready else { return }
        
        let tmp = "\(cmd) \(arg)".trimmingCharacters(in: .whitespaces)
        
        print(#function, tmp)
        
        guard let cmd = tmp.data(using: .utf8) else { return }
        
        conn.send(content: cmd, completion: .contentProcessed { error in
            
            if let _ = error {
                print(#function, "failed to initialize drone SDK")
            } else {
                print(#function, "Drone command sent successfully")
            }
            
            conn.receiveMessage { (data, cxt, completed, error) in
                guard let data = data else { return }
                let text = String(data: data, encoding: .utf8) ?? "Unknown"
                self.delegate?.onDroneStatusUpdate(msg: text)
            }
            
            })
    }
    
    func startConnection() {
        
        stopConnection()
        
        // UDP connection for command
        let queue_drone = DispatchQueue(label: "drone queue")
        udpConnection = NWConnection(host: self.host_ip, port: self.host_port, using: .udp)
        
        // Not used for bootcamp (switching among wifi, 4G, hotspot, wifi on/off ...etc )
        udpConnection?.betterPathUpdateHandler = betterPathUpdateHandler(better:)
        udpConnection?.viabilityUpdateHandler = viabilityUpdateHandler(viable:)
        
        udpConnection?.stateUpdateHandler = connectionHandler(state:)
        udpConnection?.start(queue: queue_drone)
        
        // UDP Listener for state info from device
        queue_listener_state = DispatchQueue(label: "listener state queue")
        udpListener = try? NWListener(using: .udp, on: self.local_port)
        udpListener?.newConnectionHandler = newConnectionHandler(connection:)
        udpListener?.stateUpdateHandler = listenerHandler(state:)
        udpListener?.start(queue: queue_listener_state!)
        
    }
    
    func stopConnection() {
        udpConnection?.cancel()
        udpConnection?.forceCancel()
        udpListener?.cancel()
        stateConnection?.cancel()
    }
    
}

extension Drone {
    
    private func initDroneSDK() {
        sendCommand(cmd: "command")
    }
    
    private func processDeviceData(withItems items: [Substring]) {
        let speedx = Int(Global.extractInfo(byKey: "vgx:", withItems: items) ?? "0") ?? 0
        let speedy = Int(Global.extractInfo(byKey: "vgy:", withItems: items) ?? "0") ?? 0
        let speedz = Int(Global.extractInfo(byKey: "vgz:", withItems: items) ?? "0") ?? 0
        print(#function, speedx, speedy, speedz)
        self.isIdle = (speedx + speedy + speedz) == 0
        if self.isIdle {
            self.delegate?.droneIsIdling()
        } else {
            self.delegate?.onDroneStatusUpdate(msg: "x:\(speedx) y:\(speedy) z:\(speedz)")
        }
    }
    
}

// Handlers (state, path, viability, new connection ... etc)
extension Drone {
    
    private func betterPathUpdateHandler(better: Bool) {
        print(#function, better)
    }
    
    private func viabilityUpdateHandler(viable: Bool) {
        print(#function, viable)
    }
    
    private func connectionHandler(state: NWConnection.State) {
        
        switch state {
        case .ready:
            print(#function, "\(state)")
            self.initDroneSDK()
        default:
            print(#function, "\(state)")
        }
        
        let status = "\(state)".capitalized
        
        self.delegate?.onConnectionStatusUpdate(msg: status)
        
    }
    
    private func listenerHandler(state: NWListener.State) {
        print(#function, "\(state)")
        
        let status = "\(state)".capitalized
        
        self.delegate?.onListenerStatusUpdate(msg: status)
    }
    
    private func newConnectionHandler(connection: NWConnection) {
        print(#function)
        guard let queue = queue_listener_state else { return }
        
        self.stateConnection = connection
        
        connection.start(queue: queue)
        
        self.receiveStateInfo(onConnection: connection)
    }
    
    private func receiveStateInfo(onConnection connection: NWConnection) {
        
        connection.receiveMessage(completion: { (content, ctx, complete, error) in
            if let data = content {
                if let tmp = String(data: data, encoding: .utf8) {
                    print(#function, tmp)
                    let items = tmp.split(separator: ";")
                    self.delegate?.onStatusDataArrival(withItems: items)
                    self.processDeviceData(withItems: items)
                }
            }
            if error == nil {
                Global.delay(1.0) {
                    self.receiveStateInfo(onConnection: connection)
                }
            }
        })
    }
}

