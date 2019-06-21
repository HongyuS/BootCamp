//
//  BasicView.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/13.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class BasicView: UIViewController {
    
    private var mgr = DroneManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialize label values of sliders.
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
        Global.updateLabel(rotateAngle, withValue: "\(Int(rotateAngleSlider.value))")
        
        // Make drone ready.
        var drone = Global.createDrone()
        drone.delegate = self
        mgr.drone = drone
        
    }
    
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
    
}


// MARK: Private Functions
extension BasicView {
    
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
        if let value = Global.extractInfo(byKey: "t", withItems: items) {
            Global.updateLabel(self.timeStatus, withValue: value)
        }
        
    }
}


// MARK: UI Actions
extension BasicView {
    
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(sender.value))")
    }
    
    @IBAction func rotateAngleSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(rotateAngle, withValue: "\(Int(sender.value))")
    }
    
    // Move Button actions.
    @IBAction func buttonMove(_ sender: UIButton) {
        Global.animateButton(sender)
        
        let distance = distanceSliderValue.text!
        
        let dir = MoveDirection(sender.tag)
        self.mgr.move(inDirection: dir, withDistance: distance)
        
    }
    
    // Rotate Button actions.
    @IBAction func buttonRotate(_ sender: UIButton) {
        Global.animateButton(sender)
        
        let angle = rotateAngle.text!
        
        let dir = RotateDirection(sender.tag)
        self.mgr.rotate(inDirection: dir, withDegree: angle)
        
    }
    
    // Flip Button actions.
    @IBAction func flipControl(_ sender: UIButton) {
        Global.animateButton(sender)
        
        let dir = FlipDirection(sender.tag)
        self.mgr.flip(inDirection: dir)
        
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
extension BasicView: DroneDelegate {
    
    // Status string from device
    func onStatusDataArrival(withItems items: [Substring]) {
        self.processStateData(withItems: items)
        Global.updateLabel(self.aliveStatus, withValue: "Ok")
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
