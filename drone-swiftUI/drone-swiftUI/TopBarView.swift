//
//  TopBarView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/14.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct TopBarView: View {
    // drone states
    @Binding var takeoff: Bool
    @Binding var recording: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                // MARK: TODO: send command
                self.takeoff.toggle()
            }) {
                Image(self.takeoff ? "drone.landing" : "drone.takeoff")
                    .foregroundColor(Color.primary)
            }
            .frame(width: 60, height: 60, alignment: .center)
            .background(self.takeoff ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
            .background(Blur(style: .regular))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.top, 20)
            
            HStack(spacing: 16) {
                Text("Hello, World!")
                Spacer()
                Text("Hello, World!")
                Spacer()
                Text("Hello, World!")
            }
            .padding(16)
            .padding(.top, 20)
            .frame(height: 112)
            .background(Blur(style: .regular))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 16)
            
            HStack(spacing: 0) {
                Button(action: {
                    // MARK: TODO: send command
                    self.recording.toggle()
                }) {
                    Image(systemName: self.recording ? "video.slash.fill" : "video.fill")
                        .font(.title)
                        .foregroundColor(Color.primary)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .background(self.recording ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundColor(Color.primary)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.gray.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
            }
            .background(Blur(style: .regular))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.top, 20)
        }
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(takeoff: .constant(false), recording: .constant(false))
    }
}
