//
//  LeftControllerView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct LeftControllerView: View {
    @State public var stickState: CGSize = .zero
    @State public var knobState: Double = 0
    
    @Binding var mgr: DroneManager
    
    var body: some View {
        ZStack {
            RotateWheel(knobState: $knobState)
            
            JoyStick(stickState: $stickState).opacity(0.9)
        }
        .frame(width: 228, height: 228)
        .background(Blur(style: .regular))
        .cornerRadius(114)
    }
}

struct LeftControllerView_Previews: PreviewProvider {
    static var previews: some View {
        LeftControllerView(mgr: .constant(DroneManager()))
    }
}

struct RotateWheel: View {
    @Binding public var knobState: Double
    
    var body: some View {
        ZStack {
            Image("rotateWheel")
            
            GeometryReader {
                RotateWheelPointer(knobState: self.$knobState, frame: $0.frame(in: .local))
            }
        }
    }
}

struct RotateWheelPointer: View {
    @Binding public var knobState: Double
    @GestureState private var dragLocation: CGPoint = .zero
    public var frame: CGRect
    
    var body: some View {
        Image("rotatePointer")
            .rotationEffect(Angle(degrees: knobState), anchor: .center)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
            .gesture(DragGesture()
                .updating($dragLocation, body: { value, state, transaction in
                    state = value.location
                })
                .onChanged { value in
                    let angle: Double = -((Double(atan2(Double(self.frame.midX - self.dragLocation.x), Double(self.frame.midY - self.dragLocation.y)))) / .pi) * 180
                    self.knobState = angle
                }
                .onEnded { angle in
                    // MARK: TODO: send rotate command
                    self.knobState = 0
                }
        )
    }
}

struct JoyStick: View {
    @Binding public var stickState: CGSize
    
    var body: some View {
        Circle()
            .fill(Color.secondary)
            .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 16
            ), alignment: .center)
            .frame(width: 80, height: 80)
            .cornerRadius(40)
            .shadow(color: Color.black.opacity(0.9), radius: 20, x: 0, y: 0)
            .offset(x:stickState.width, y: stickState.height)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
            .gesture(DragGesture()
                .onChanged { value in
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
                    // MARK: TODO: send move command
                    self.stickState = .zero
                }
        )
    }
}
