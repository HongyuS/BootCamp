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
    
    var body: some View {
        ZStack {
            
            Color.white
            
            Color.black
                .frame(width: 80, height: 80)
                .cornerRadius(40)
                .offset(y: stickState.height)
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
                .gesture(
                    DragGesture().onChanged { value in
                        self.stickState = value.translation
                        if self.stickState.height > 70 {
                            self.stickState.height = 70
                        } else if self.stickState.height < -70 {
                            self.stickState.height = -70
                        }
                    }
                    .onEnded { value in
                        self.stickState = .zero
                    }
                )
        }
        .frame(width: 228, height: 228)
        .cornerRadius(114)
        .opacity(0.5)
    }
}

struct LeftControllerView_Previews: PreviewProvider {
    static var previews: some View {
        LeftControllerView()
    }
}
