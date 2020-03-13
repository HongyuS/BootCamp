//
//  BasicPlusView.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/17.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class BasicPlusView: UIViewController {
    
    private var mgr = DroneManager()
    
    // Mode Control outlet.
    @IBOutlet weak var mode: UISegmentedControl!
    
    // Motion Button outlet.
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // Sliders and their labels.
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSliderValue: UILabel!
    @IBOutlet weak var rotateAngleSlider: UISlider!
    @IBOutlet weak var rotateAngle: UILabel!
    
    // Drone Status labels.
    @IBOutlet weak var timeStatus: UILabel!
    @IBOutlet weak var heightStatus: UILabel!
    @IBOutlet weak var batteryStatus: UIProgressView!
    @IBOutlet weak var droneStatus: UILabel!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var aliveStatus: UILabel!
    
    // Switch to enalbe flip gestures.
    @IBOutlet weak var flipSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // "Do any additional setup after loading the view."
        
        // Initialize label values of sliders.
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
        Global.updateLabel(rotateAngle, withValue: "\(Int(rotateAngleSlider.value))")
        
        // Create drone and pass it to the manager.
        var drone = Global.createDrone()
        drone.delegate = self
        mgr.drone = drone
        
    }
    
}


// MARK: Private Functions
extension BasicPlusView {
    
    private func resetStatus() {
        Global.updateProgress(self.batteryStatus, withValue: "0")
        Global.updateLabel(self.aliveStatus, withValue: "??")
        Global.updateLabel(self.droneStatus, withValue: "??")
        Global.updateLabel(self.connectionStatus, withValue: "??")
        Global.updateLabel(self.timeStatus, withValue: "0")
        Global.updateLabel(self.heightStatus, withValue: "0")
    }
    
    private func processStateData(withItems items: [Substring]) {
        if let value = Global.extractInfo(byKey: "bat", withItems: items) {
            Global.updateProgress(self.batteryStatus, withValue: value)
        }
        if let value = Global.extractInfo(byKey: "h", withItems: items) {
            Global.updateLabel(self.heightStatus, withValue: value)
        }
        if let value = Global.extractInfo(byKey: "time", withItems: items) {
            Global.updateLabel(self.timeStatus, withValue: value)
        }
        
    }
}


// MARK: UI Actions
extension BasicPlusView {
    
    @IBAction func modeControl(_ sender: UISegmentedControl) {
        // Switch color of `UP` and `DOWN` button.
        switch sender.selectedSegmentIndex {
        case 0:
            upButton.tintColor = .systemBlue
            downButton.tintColor = .systemBlue
        case 1:
            upButton.tintColor = .systemOrange
            downButton.tintColor = .systemOrange
        default:
            print(#function)
        }
    }
    
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(sender.value))")
    }
    
    @IBAction func rotateAngleSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(rotateAngle, withValue: "\(Int(sender.value))")
    }
    
    @IBAction func resetSliderValue(_ sender: UIButton) {
        switch ResetButton(sender.tag) {
        case .distance:
            distanceSlider.value = 50
            Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
        case .angle:
            rotateAngleSlider.value = 90
            Global.updateLabel(rotateAngle, withValue: "\(Int(rotateAngleSlider.value))")
        }
    }
    
    // Motion Button actions.
    @IBAction func buttonMotion(_ sender: UIButton) {
        Global.animateButton(sender)
        
        let distance = distanceSliderValue.text!
        let angle = rotateAngle.text!
        
        switch MotionMode(mode.selectedSegmentIndex) {
        case .horizontal:
            switch MotionButton(sender.tag) {
            case .up, .down:
                let dir = MoveDirection(sender.tag + 4)
                self.mgr.move(inDirection: dir, withDistance: distance)
            case .left, .right:
                let dir = MoveDirection(sender.tag)
                self.mgr.move(inDirection: dir, withDistance: distance)
            }
        case .rotation: // `Vertical` or `Rotation` Mode
            switch MotionButton(sender.tag) {
            case .up, .down:
                let dir = MoveDirection(sender.tag)
                self.mgr.move(inDirection: dir, withDistance: distance)
            case .left, .right:
                let dir = RotateDirection(sender.tag - 2)
                self.mgr.rotate(inDirection: dir, withDegree: angle)
            }
        }
    }
    
    // Swipe Gesture actions.
    @IBAction func flipControl(_ sender: UISwipeGestureRecognizer) {
        if flipSwitch.isOn {
            switch sender.direction {
            case .up: self.mgr.flip(inDirection: .forward)
            case .down: self.mgr.flip(inDirection: .back)
            case .left: self.mgr.flip(inDirection: .left)
            case .right: self.mgr.flip(inDirection: .right)
            default: return
            }
        }
    }
    
    // Master Button actions.
    @IBAction func buttonMaster(_ sender: UIButton) {
        Global.animateButton(sender)
        
        switch MasterButton(sender.tag) {
        case .takeoff:
            self.mgr.takeoff()
        case .landing:
            self.mgr.landing()
        case .start:
            resetStatus()
            self.mgr.start()
        case .stop:
            resetStatus()
            self.mgr.stop()
        }
        
    }
    
}


// MARK: Drone Delegate
extension BasicPlusView: DroneDelegate {
    
    // Status string from device
    func onStatusDataArrival(withItems items: [Substring]) {
        self.processStateData(withItems: items)
        Global.updateLabel(self.aliveStatus, withValue: "Ok")
    }
    
    func onVideoDataArrival(data: Array<UInt8>) {
        print(#function)
    }
    
    func onConnectionStatusUpdate(msg: String) {
        Global.updateLabel(self.connectionStatus, withValue: msg)
    }
    
    func onListenerStatusUpdate(msg: String) {
        print("TODO:", #function)
    }
    
    func onDroneStatusUpdate(msg: String) {
        Global.updateLabel(self.droneStatus, withValue: msg)
    }
    
    func droneIsIdling() {
        Global.updateLabel(self.droneStatus, withValue: "Idle")
    }
    
}
