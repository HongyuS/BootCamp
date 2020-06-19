//
//  UIBlurBackgroundView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/15.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//
//  Reference:
//  `Blur Effect inside SwiftUI` written by Richard Mullinix
//  https://medium.com/@edwurtle/blur-effect-inside-swiftui-a2e12e61e750
//

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
