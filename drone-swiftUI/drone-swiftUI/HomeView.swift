//
//  ContentView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI
import Network

// MARK: HomeView UI
struct HomeView: View {
    
    @State private var mgr = DroneManager()
    
    // Drone states
    @State private var takeoff: Bool = false
    @State private var recording: Bool = false
    @State private var height: String = ""
    @State private var time: String = ""
    @State private var battery: Int = 100
    @State private var connectionStatus: String = ""
    @State private var droneStatus: String = "Unknown"
    
    var body: some View {
        ZStack {
            
            Text("Hello, World!")
            
            VStack {
                TopBarView(mgr: $mgr,
                           takeoff: $takeoff,
                           recording: $recording,
                           height: $height,
                           time: $time,
                           battery: $battery,
                           connectionStatus: $connectionStatus,
                           droneStatus: $droneStatus
                )
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 20, x: 0, y: 10)
                    .offset(x: 0, y: -36)
                
                Spacer()
                
                HStack {
                    LeftControllerView(mgr: $mgr)
                        .shadow(
                            color: Color.black.opacity(0.4),
                            radius: 20, x: 0, y: 10)
                    
                    Spacer()
                    
                    RightControllerView(mgr: $mgr)
                        .shadow(
                            color: Color.black.opacity(0.4),
                            radius: 20, x: 0, y: 10)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.blue)
        .onAppear {
            let drone = Drone(
                host: device_ip_address,
                port: device_ip_port,
                port_local: local_ip_port_state,
                port_video: local_ip_port_video)
            drone.delegate = self
            self.mgr.drone = drone
            self.mgr.start()
            print("load drone success")
        } .onDisappear {
            self.mgr.stop()
        }
    }
}

// MARK: HomeView Previews
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView: DroneDelegate {
    
    private func processStateData(withItems items: [Substring]) {
        if let value = Global.extractInfo(byKey: "bat", withItems: items) {
            DispatchQueue.main.async {
                self.battery = Int(value) ?? 0
            }
        }
        if let value = Global.extractInfo(byKey: "h", withItems: items) {
            DispatchQueue.main.async {
                self.height = value
            }
        }
        if let value = Global.extractInfo(byKey: "time", withItems: items) {
            DispatchQueue.main.async {
                self.time = value
            }
        }
    }
    
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
