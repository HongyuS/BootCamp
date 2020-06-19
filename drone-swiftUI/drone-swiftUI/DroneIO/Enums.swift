//
//  Enums.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation

// TODO: all init() DO NOT catch index out of range !!!

// Commands to be sent to drone (see spec)
enum MoveDirection: String, CaseIterable {
    case up
    case down
    case left
    case right
    case forward
    case back
    init(_ ix:Int) {
        self = MoveDirection.allCases[ix]
    }
}

// Commands to be sent to drone (see spec)
enum RotateDirection: String, CaseIterable {
    case ccw
    case cw
    init(_ ix:Int) {
        self = RotateDirection.allCases[ix]
    }
}

// Commands to be sent to drone (see spec)
enum FlipDirection: String, CaseIterable {
    case left = "l"
    case right = "r"
    case forward = "f"
    case back = "b"
    init(_ ix:Int) {
        self = FlipDirection.allCases[ix]
    }
}

// Joystick directions
enum JoystickDirection {
    case up
    case down
    case left
    case right
    case center
}

// Vertical Knob directions
enum VerticalKnobDirection {
    case up
    case down
    case center
}
