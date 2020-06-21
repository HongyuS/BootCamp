//
//  RightControllerView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/13.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct RightControllerView: View {
    
    @State var stickState = CGSize.zero
    @State var stickDirection: VerticalKnobDirection = .center
    
    @EnvironmentObject var mgr: DroneManager
    
    var body: some View {
        ZStack {
            Color.secondary.opacity(0.9)
                .frame(width: 72, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.black.opacity(0.7), radius: 10, x: 0, y: 0)
                .offset(y: stickState.height)
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
                .gesture(
                    DragGesture().onChanged { value in
                        // Update knob location
                        self.stickState = value.translation
                        // Set knob direction
                        if self.stickState.height > 0 {
                            self.stickDirection = .down
                        } else if self.stickState.height < 0 {
                            self.stickDirection = .up
                        }
                        // Limit knob movement
                        if self.stickState.height > 83 {
                            self.stickState.height = 83
                        } else if self.stickState.height < -83 {
                            self.stickState.height = -83
                        }
                    }
                    .onEnded { value in
                        // Send vertical move command
                        if abs(self.stickState.height) > 13 {
                            switch self.stickDirection {
                            case .up:
                                self.mgr.move(inDirection: .up, withDistance: "\((-Int((self.stickState.height+13)/10)+3)*10)")
                            case .down:
                                self.mgr.move(inDirection: .down, withDistance: "\((Int((self.stickState.height-13)/10)+3)*10)")
                            case .center:
                                print("Vertical knob not moved!")
                            }
                        }
                        // Reset vertical knob state
                        self.stickState = .zero
                        self.stickDirection = .center
                    }
                )
        }
        .frame(width: 80, height: 228)
        .background(Blur(style: .regular))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct RightControllerView_Previews: PreviewProvider {
    static var previews: some View {
        RightControllerView().environmentObject(DroneManager.preview)
    }
}
