//
//  ContentView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    // drone states
    @State private var takeoff: Bool = false
    @State private var recording: Bool = false
    
    var body: some View {
        ZStack {
            
            Text("Hello, World!")
            
            VStack {
                TopBarView(takeoff: $takeoff, recording: $recording)
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 20, x: 0, y: 10)
                    .offset(x: 0, y: -36)
                
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
        .background(Color.blue)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
