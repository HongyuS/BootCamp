//
//  ContentView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI
import Network

// MARK: - HomeView UI

struct HomeView: View {
    
    // ViewModel
    @ObservedObject private var mgr = DroneManager {
        Drone(host: device_ip_address,
              port: device_ip_port,
              port_local: local_ip_port_state,
              port_video: local_ip_port_video)
    }
    
    // Drone states
    @State private var takeoff: Bool = false
    @State private var recording: Bool = false
    
    var body: some View {
        ZStack {
            
            Text("Hello, World!")
            
            VStack {
                TopBarView(mgr: mgr,
                           takeoff: $takeoff,
                           recording: $recording
                )
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 20, x: 0, y: 10)
                    .offset(x: 0, y: -36)
                
                Spacer()
                
                HStack {
                    LeftControllerView(mgr: mgr)
                        .shadow(
                            color: Color.black.opacity(0.4),
                            radius: 20, x: 0, y: 10)
                    
                    Spacer()
                    
                    RightControllerView(mgr: mgr)
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
            self.mgr.drone?.delegate = self.mgr
            self.mgr.start()
            print("load drone success")
        } .onDisappear {
            self.mgr.stop()
        }
    }
}

// MARK: - HomeView Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
