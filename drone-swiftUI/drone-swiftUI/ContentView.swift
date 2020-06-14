//
//  ContentView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            Text("Hello, World!")
            
            VStack {
                TopBarView()
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                HStack {
                    LeftControllerView()
                        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    Spacer()
                    
                    RightControllerView()
                        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
