//
//  DroneNWHandler.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/20.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import Foundation
import Network

class DroneNWHandler: DeviceInterface {
    
    var delegate: DroneDelegate?
    
    private var host_ip: NWEndpoint.Host!
    private var host_port: NWEndpoint.Port!
    private var local_port: NWEndpoint.Port!
    private var local_video_port: NWEndpoint.Port!
    
    private var cmdConnection: NWConnection?
    private var statusListener: NWListener?
    private var videoListener: NWListener?
    private var queue_listener_state: DispatchQueue?
    private var queue_listener_video: DispatchQueue?
    
    private var stateConnection: NWConnection?
    private var videoConnection: NWConnection?
    
    required init(host: NWEndpoint.Host, port: NWEndpoint.Port, port_local: NWEndpoint.Port, port_video: NWEndpoint.Port) {
        self.host_ip = host
        self.host_port = port
        self.local_port = port_local
        self.local_video_port = port_video
    }
    
    func sendCommand(cmd: String) {
        sendCommand(cmd: cmd, arg: "")
    }
    
    func sendCommand(cmd: String, arg: String){
        
        guard let conn = self.cmdConnection, conn.state == .ready else { return }
        
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
        cmdConnection = NWConnection(host: self.host_ip, port: self.host_port, using: .udp)
        
        // Not used for bootcamp (switching among wifi, 4G, hotspot, wifi on/off ...etc )
        cmdConnection?.betterPathUpdateHandler = { better in
            print("betterPathUpdateHandler: Better path available? \(better)")
        }
        cmdConnection?.viabilityUpdateHandler = { viable in
            print("viabilityUpdateHandler: Viable? \(viable)")
        }
        
        cmdConnection?.stateUpdateHandler = { state in
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
        cmdConnection?.start(queue: queue_drone)
        
        // UDP Listener for state info from device
        queue_listener_state = DispatchQueue(label: "listener state queue")
        statusListener = try? NWListener(using: .udp, on: self.local_port)
        statusListener?.newConnectionHandler = { connection in
            print("Start status connection")
            guard let queue = self.queue_listener_state else { return }
            
            self.stateConnection = connection
            connection.start(queue: queue)
            self.receiveStateInfo(onConnection: connection)
        }
        statusListener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Listening on port \(String(describing: self.statusListener!.port!))")
            case .failed(let error):
                print("Listener failed with error: \(error)")
            default:
                print(#function, "\(state)")
            }
            
            let status = "\(state)".capitalized
            self.delegate?.onListenerStatusUpdate(msg: status)
        }
        statusListener?.start(queue: queue_listener_state!)
        
        // UDP Listener for video data from device
        queue_listener_video = DispatchQueue(label: "listener video queue")
        videoListener = try? NWListener(using: .udp, on: self.local_video_port)
        videoListener?.newConnectionHandler = { connection in
            print("Start video connection")
            guard let queue = self.queue_listener_video else { return }
            
            self.videoConnection = connection
            connection.start(queue: queue)
            self.receiveVideoData(onConnection: connection)
        }
        videoListener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Listening on port \(String(describing: self.videoListener!.port!))")
            case .failed(let error):
                print("Listener failed with error: \(error)")
            default:
                print(#function, "\(state)")
            }
        }
        videoListener?.start(queue: queue_listener_video!)
        
    }
    
    func stopConnection() {
        cmdConnection?.cancel()
        cmdConnection?.forceCancel()
        statusListener?.cancel()
        stateConnection?.cancel()
        videoListener?.cancel()
        videoConnection?.cancel()
    }
    
    private func initDroneSDK() {
        sendCommand(cmd: "command")
    }
    
}

// MARK: - Data Receivers
// Receive data from listeners
extension DroneNWHandler {
    
    private func receiveStateInfo(onConnection connection: NWConnection) {
        
        connection.receiveMessage(completion: { (content, context, isComplete, error) in
            if let data = content {
                if let tmp = String(data: data, encoding: .utf8) {
                    print("Received drone status message:\n\(tmp)\n")
                    let items = tmp.split(separator: ";")
                    self.delegate?.onStatusDataArrival(with: items)
                }
                if error == nil {
                    self.receiveStateInfo(onConnection: connection)
                }
            }
        })
    }
    
    private func receiveVideoData(onConnection connection: NWConnection) {
        
        connection.receiveMessage(completion: { (content, context, isComplete, error) in
            if let data = content {
                print("Received video data of size \(data.count) bytes")
                self.delegate?.onVideoDataArrival(with: data)
                
                if error == nil {
                        self.receiveVideoData(onConnection: connection)
                }
            }
        })
    }
}


