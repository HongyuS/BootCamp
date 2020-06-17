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
            RotateWheel(knobState: $knobState, mgr: $mgr)
            
            JoyStick(stickState: $stickState).opacity(0.9)
        }
        .frame(width: 228, height: 228)
        .background(Blur(style: .regular))
        .cornerRadius(114)
    }
}

struct LeftControllerView_Previews: PreviewProvider {
    static var previews: some View {
        LeftControllerView(mgr: .constant(DroneManager { Drone(host: "0.0.0.0", port: 0, port_local: 0, port_video: 0) }))
    }
}

// MARK: - Rotate Wheel
// A view that tells the drone to rotate
struct RotateWheel: View {
    @Binding public var knobState: Double
    @Binding var mgr: DroneManager
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: knobState > 0 ? 0 : CGFloat((360+knobState)/360),
                      to: knobState > 0 ? CGFloat(knobState/360) : 1
                )
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))]), startPoint: .trailing, endPoint: .leading),
                    style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .blur(radius: 10)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 168, height: 168, alignment: .center)
            
            Image("rotateWheel")
            
            GeometryReader {
                RotateWheelPointer(knobState: self.$knobState, mgr: self.$mgr, frame: $0.frame(in: .local))
            }
        }
    }
}

struct RotateWheelPointer: View {
    @Binding var knobState: Double
    @GestureState private var dragLocation: CGPoint = .zero
    @Binding var mgr: DroneManager
    
    public var frame: CGRect
    
    var body: some View {
        Image("rotatePointer")
            .rotationEffect(Angle(degrees: knobState), anchor: .center)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
            .gesture(DragGesture()
                .updating($dragLocation, body: { value, state, transaction in
                    state = value.location
                })
                .onChanged { _ in
                    let angle: Double = -((Double(atan2(Double(self.frame.midX - self.dragLocation.x), Double(self.frame.midY - self.dragLocation.y)))) / .pi) * 180
                    self.knobState = angle
                }
                .onEnded { _ in
                    // Send rotate command
                    switch self.knobState > 0 {
                    case true:
                        self.mgr.rotate(inDirection: .cw, withDegree: "\(Int(self.knobState))")
                    case false:
                        self.mgr.rotate(inDirection: .ccw, withDegree: "\(-Int(self.knobState))")
                    }
                    // Reset knob state
                    self.knobState = 0
                }
        )
    }
}

// MARK: - Joystick View
// A view to control horizontal motion of the drone
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
