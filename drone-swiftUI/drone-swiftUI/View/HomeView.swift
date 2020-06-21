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
    @EnvironmentObject var mgr: DroneManager
    
    // Drone states
    @State private var takeoff: Bool = false
    @State private var recording: Bool = false
    
    var body: some View {
        ZStack {
            
            VideoView(mgr: mgr)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TopBarView(takeoff: $takeoff,
                           recording: $recording
                )
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 20, x: 0, y: 10)
                
                Spacer()
                
                HStack {
                    LeftControllerView()
                        .shadow(
                            color: Color.black.opacity(0.4),
                            radius: 20, x: 0, y: 10)
                    
                    Spacer()
                    
                    RightControllerView()
                        .shadow(
                            color: Color.black.opacity(0.4),
                            radius: 20, x: 0, y: 10)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
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
        HomeView().environmentObject(DroneManager {
            Drone(host: "0.0.0.0",
                  port: 0,
                  port_local: 1,
                  port_video: 2)
        })
    }
}
