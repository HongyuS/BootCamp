//
//  LeftControllerView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct LeftControllerView: View {
    @State var stickState = CGSize.zero
    @State var knobState: Double = 0
    
    var body: some View {
        ZStack {
            RotateWheel(knobState: $knobState)
            
//            Text("\(stickState.width), \(stickState.height)")
            
            JoyStick(stickState: $stickState)
        }
        .frame(width: 228, height: 228)
        .cornerRadius(114)
    }
}

struct LeftControllerView_Previews: PreviewProvider {
    static var previews: some View {
        LeftControllerView()
    }
}

struct RotateWheel: View {
    @Binding var knobState: Double
    
    var body: some View {
        Image("rotateWheel")
            .rotationEffect(Angle(degrees: knobState), anchor: .center)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
            .gesture(
                RotationGesture().onChanged { angle in
                    self.knobState = angle.degrees
                }
                .onEnded { angle in
                    self.knobState = 0
                }
        )
    }
}

struct JoyStick: View {
    @Binding var stickState: CGSize
    
    var body: some View {
        Circle()
            .fill(Color.yellow)
            .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 12), alignment: .center)
            .frame(width: 80, height: 80)
            .cornerRadius(40)
            .shadow(color: Color.black.opacity(0.7), radius: 10, x: 0, y: 0)
            .offset(x:stickState.width, y: stickState.height)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
            .gesture(
                DragGesture().onChanged { value in
                    if value.translation.width.magnitude > value.translation.height.magnitude {
                        self.stickState.width = value.translation.width
                        self.stickState.height = 0
                        if self.stickState.width > 70 {
                            self.stickState.width = 70
                        } else if self.stickState.width < -70 {
                            self.stickState.width = -70
                        }
                    } else {
                        self.stickState.height = value.translation.height
                        self.stickState.width = 0
                        if self.stickState.height > 70 {
                            self.stickState.height = 70
                        } else if self.stickState.height < -70 {
                            self.stickState.height = -70
                        }
                    }
                }
                .onEnded { value in
                    // MARK: TODO: send command
                    self.stickState = .zero
                }
        )
    }
}
