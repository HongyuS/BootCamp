//
//  DroneData.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/18.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import Foundation

struct DroneData {
    var isIdle: Bool = false
    var battery: Int?
    var height: String?
    var time: String?
    var connectionStatus: String?
    var droneStatus: String?
    
    var videoFrame: Data?
}
