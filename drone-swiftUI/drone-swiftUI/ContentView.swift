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
                HStack {
                    Text("Hello, World!")
                    Spacer()
                }
                .frame(height: 80)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    LeftControllerView()
                    Spacer()
                    RightControllerView()
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
