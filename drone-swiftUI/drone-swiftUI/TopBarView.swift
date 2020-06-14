//
//  TopBarView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/14.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI

struct TopBarView: View {
    var body: some View {
        HStack {
            Text("Hello, World!")
            Spacer()
        }
        .frame(height: 80)
        .background(Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 16)
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
