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
    @Binding var mgr: DroneManager
    
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
                        self.stickState = value.translation
                        if self.stickState.height > 83 {
                            self.stickState.height = 83
                        } else if self.stickState.height < -83 {
                            self.stickState.height = -83
                        }
                    }
                    .onEnded { value in
                        // MARK: TODO: send command
                        self.stickState = .zero
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
        RightControllerView(mgr: .constant(DroneManager()))
    }
}
