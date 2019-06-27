//
//  GestureViewController.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/24.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {
    
    private var mgr = DroneManager()
    
    // Sliders and their labels.
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSliderValue: UILabel!
    
    // Drone Status labels.
    @IBOutlet weak var timeStatus: UILabel!
    @IBOutlet weak var heightStatus: UILabel!
    @IBOutlet weak var batteryStatus: UIProgressView!
    @IBOutlet weak var droneStatus: UILabel!
    @IBOutlet weak var connectionStatus: UILabel!
    
    // Switch to enalbe flip gestures.
    @IBOutlet weak var flipSwitch: UISwitch!
    
    @IBOutlet weak var touchPad: UIView!
    // @IBOutlet var rotate: UIRotationGestureRecognizer!
    // @IBOutlet var swipeForward: UISwipeGestureRecognizer!
    // @IBOutlet var swipeBack: UISwipeGestureRecognizer!
    // @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    // @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    // @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    // @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addGesture()
        
        // Initialize label values of sliders.
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
        
        // Create drone and pass it to the manager.
        var drone = Global.createDrone()
        drone.delegate = self
        mgr.drone = drone
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: UI Actions
extension GestureViewController {
    
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(sender.value))")
    }
    
    @IBAction func resetSliderValue(_ sender: UIButton) {
        distanceSlider.value = 50
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
    }
    
    // Rotate
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        guard sender.state == UIGestureRecognizer.State.ended else { return }
        
        let angle = Double(sender.rotation) / Double.pi * 180
        switch Double(sender.rotation) {
        case 0 ..< 360:
            self.mgr.rotate(inDirection: .cw, withDegree: "\(Int(angle))")
        default:
            self.mgr.rotate(inDirection: .ccw, withDegree: "\(-Int(angle))")
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


// MARK: Private Functions
extension GestureViewController {
    
    private func addGesture() {
        
        let dir: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for d in dir {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(singleFingerSwipeControl(_:)))
            swipe.direction = d
            swipe.numberOfTouchesRequired = 1
            touchPad.addGestureRecognizer(swipe)
        }
        
        for d in dir[0...1] {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(doubleFingerSwipeControl(_:)))
            swipe.direction = d
            swipe.numberOfTouchesRequired = 2
            touchPad.addGestureRecognizer(swipe)
        }
        
    }
    
    // Single finger Swipe Gesture actions.
    @objc private func singleFingerSwipeControl(_ sender: UISwipeGestureRecognizer) {
        switch flipSwitch.isOn {
        case true:
            var dir: FlipDirection?
            
            switch sender.direction {
            case .up: dir = FlipDirection(2)
            case .down: dir = FlipDirection(3)
            case .left: dir = FlipDirection(0)
            case .right: dir = FlipDirection(1)
            default: return
            }
            
            self.mgr.flip(inDirection: dir!)
            
        default:
            var dir: MoveDirection?
            
            switch sender.direction {
            case .up: dir = MoveDirection(4)
            case .down: dir = MoveDirection(5)
            case .left: dir = MoveDirection(2)
            case .right: dir = MoveDirection(3)
            default: return
            }
            
            self.mgr.move(inDirection: dir!, withDistance: distanceSliderValue.text ?? "50")
            
        }
    }
    
    // Single finger Swipe Gesture actions.
    @objc private func doubleFingerSwipeControl(_ sender: UISwipeGestureRecognizer) {
        var dir: MoveDirection?
        
        switch sender.direction {
        case .up: dir = MoveDirection(0)
        case .down: dir = MoveDirection(1)
        default: return
        }
        
        self.mgr.move(inDirection: dir!, withDistance: distanceSliderValue.text ?? "50")
    }
    
    private func resetStatus() {
        Global.updateProgress(self.batteryStatus, withValue: "0")
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


// MARK: Drone Delegate
extension GestureViewController: DroneDelegate {
    
    // Status string from device
    func onStatusDataArrival(withItems items: [Substring]) {
        self.processStateData(withItems: items)
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
