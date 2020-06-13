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
    
    var body: some View {
        ZStack {
            Color.black
                .frame(width: 72, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
                        self.stickState = .zero
                    }
                )
        }
        .frame(width: 80, height: 228)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .opacity(0.5)
    }
}

struct RightControllerView_Previews: PreviewProvider {
    static var previews: some View {
        RightControllerView()
    }
}
