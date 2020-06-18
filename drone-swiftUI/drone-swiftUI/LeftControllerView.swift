//
//  LeftControllerView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct LeftControllerView: View {
    @State private var stickState: CGSize = .zero
    @State private var knobState: Double = 0
    
    var mgr: DroneManager
    
    var body: some View {
        ZStack {
            RotateWheel(knobState: $knobState, mgr: mgr)
            Joystick(stickState: $stickState, mgr: mgr)
        }
        .frame(width: 228, height: 228)
        .background(Blur(style: .regular))
        .cornerRadius(114)
    }
}

struct LeftControllerView_Previews: PreviewProvider {
    static var previews: some View {
        LeftControllerView(mgr: DroneManager {
            Drone(host: "0.0.0.0",
                  port: 0,
                  port_local: 0,
                  port_video: 0)
        })
    }
}

// MARK: - Rotate Wheel
// A view that tells the drone to rotate
struct RotateWheel: View {
    
    @Binding var knobState: Double
    
    var mgr: DroneManager
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: knobState > 0 ? 0 : CGFloat((360+knobState)/360),
                      to: knobState > 0 ? CGFloat(knobState/360) : 1
                )
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))]),
                                   startPoint: .trailing,
                                   endPoint: .leading),
                    style: StrokeStyle(lineWidth: 20,
                                       lineCap: .butt,
                                       lineJoin: .round,
                                       miterLimit: .infinity,
                                       dash: [20, 0],
                                       dashPhase: 0)
                )
                .blur(radius: 10)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 168, height: 168)
            
            Image("rotateWheel")
            
            GeometryReader {
                RotateWheelPointer(knobState: self.$knobState, mgr: self.mgr, frame: $0.frame(in: .local))
            }
        }
    }
}

struct RotateWheelPointer: View {
    
    @Binding var knobState: Double
    @GestureState private var dragLocation: CGPoint = .zero
    
    var mgr: DroneManager
    
    var frame: CGRect
    
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
                        self.mgr.rotate(inDirection: .cw, withDegree: "\(Int(self.knobState/15)*15)")
                    case false:
                        self.mgr.rotate(inDirection: .ccw, withDegree: "\(-Int(self.knobState/15)*15)")
                    }
                    // Reset knob state
                    self.knobState = 0
                }
        )
    }
}

// MARK: - Joystick View
// A view to control horizontal motion of the drone
struct Joystick: View {
    
    @Binding var stickState: CGSize
    @State var joystickDirection: JoystickDirection = .center
    
    var mgr: DroneManager
    
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
                        // Update joystick location
                        self.stickState.width = value.translation.width
                        self.stickState.height = 0
                        // Limit joystick movement (horizontal)
                        if self.stickState.width > 70 {
                            self.stickState.width = 70
                        } else if self.stickState.width < -70 {
                            self.stickState.width = -70
                        }
                        // Set joystickDirection
                        if self.stickState.width > 0 {
                            self.joystickDirection = .right
                        } else {
                            self.joystickDirection = .left
                        }
                    } else {
                        // Update joystick location
                        self.stickState.height = value.translation.height
                        self.stickState.width = 0
                        // Limit joystick movement (vertical)
                        if self.stickState.height > 70 {
                            self.stickState.height = 70
                        } else if self.stickState.height < -70 {
                            self.stickState.height = -70
                        }
                        // Set joystickDirection
                        if self.stickState.height > 0 {
                            self.joystickDirection = .down
                        } else {
                            self.joystickDirection = .up
                        }
                    }
                }
                .onEnded { value in
                    // Send horizontal move command
                    switch self.joystickDirection {
                    case .up:
                        self.mgr.move(inDirection: .forward, withDistance: "\((-Int(self.stickState.height/10)+3)*10)")
                    case .down:
                        self.mgr.move(inDirection: .back, withDistance: "\((Int(self.stickState.height/10)+3)*10)")
                    case .left:
                        self.mgr.move(inDirection: .left, withDistance: "\((-Int(self.stickState.width/10)+3)*10)")
                    case .right:
                        self.mgr.move(inDirection: .right, withDistance: "\((Int(self.stickState.width/10)+3)*10)")
                    case .center:
                        print("Joystick not moved!")
                    }
                    // Reset stick state
                    self.stickState = .zero
                }
        )
    }
}
