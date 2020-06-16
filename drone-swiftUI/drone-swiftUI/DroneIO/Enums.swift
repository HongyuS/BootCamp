//
//  Enums.swift
//  drone-swiftUI
//
//  Created by Kinley Lam (SSE) on 2019/6/11.
//  Copyright © 2019 Kinley Lam (SSE). All rights reserved.
//

import Foundation

// MARK: ??
// TODO: all init() DO NOT catch index out of range !!!

// modes of the motion
enum MotionMode: Int, CaseIterable {
    case horizontal
    case rotation
    init(_ ix:Int) {
        self = MotionMode.allCases[ix]
    }
}

// Motion Buttons on the UI
enum MotionButton: Int, CaseIterable {
    case up
    case down
    case left
    case right
    init(_ ix:Int) {
        self = MotionButton.allCases[ix]
    }
}

// Master Buttons on the UI
enum MasterButton: Int, CaseIterable {
    case takeoff
    case landing
    case start
    case stop
    init(_ ix:Int) {
        self = MasterButton.allCases[ix]
    }
}

// Reset Buttons on the UI
enum ResetButton: Int, CaseIterable {
    case distance
    case angle
    init(_ ix:Int) {
        self = ResetButton.allCases[ix]
    }
}

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

// Future
enum JoystickDirection: Int, CaseIterable {
    case up
    case down
    case left
    case right
    case center
    init(_ ix:Int) {
        self = JoystickDirection.allCases[ix]
    }
}
