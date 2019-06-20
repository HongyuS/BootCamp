//
//  BasicPlusView.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/17.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class BasicPlusView: UIViewController {
    
    // Mode Control outlet.
    @IBOutlet weak var mode: UISegmentedControl!
    
    // Motion Button outlet.
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // Distance Slider outlet and action to change value label.
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSliderValue: UILabel!
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(sender.value))")
    }
    
    // Rotation Angle Slider outlet and action to change value label.
    @IBOutlet weak var rotateAngleSlider: UISlider!
    @IBOutlet weak var rotateAngle: UILabel!
    @IBAction func rotateAngleSliderValueChange(_ sender: UISlider) {
        Global.updateLabel(rotateAngle, withValue: "\(Int(sender.value))")
    }
    
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
        
    }
    
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
    
}

// MARK: Actions of buttons and gestures.
extension BasicPlusView {
    
    // Motion Button actions:
        // 1. moveForward or moveUp
        // 2. moveBack or moveDown
        // 3. moveLeft or rotateLeft
        // 4. moveRight or rotateRight
    @IBAction func buttonMotion(_ sender: UIButton) {
        switch MotionMode(mode.selectedSegmentIndex) {
        case .horizontal:
            switch MotionButton(sender.tag) {
            case .up: // `Forward` Button
                print("Move Forward")
            case .down: // `Bcak` Button
                print("Move Back")
            case .left: // `Left` Button
                print("Move Left")
            case .right: // `Right` Button
                print("Move Right")
            }
        case .rotation: // `Vertical` or `Rotation` Mode
            switch MotionButton(sender.tag) {
            case .up: // `Up` Button
                print("Move Up")
            case .down: // `Down` Button
                print("Move Down")
            case .left: // `Left` Button (Rotate)
                print("Rotate Left")
            case .right: // `Right` Button (Rotate)
                print("Rotate Right")
            }
        }
    }
    
    // Swipe Gesture actions:
        // UP: flip forward;
        // DOWN: flip back;
        // LEFT: flip left;
        // RIGHT: flip right.
    @IBAction func flipControl(_ sender: UISwipeGestureRecognizer) {
        if flipSwitch.isOn {
            switch sender.direction {
            case .up: // Swipe UP on the screen.
                print("Flip FORWARD")
            case .down: // Swipe DOWN on the screen.
                print("Flip BACK")
            case .left: // Swipe LEFT on the screen.
                print("Flip LEFT")
            case .right: // Swipe RIGHT on the screen.
                print("Flip RIGHT")
            default:
                print(#function)
            }
        }
    }
    
    // Master Button actions:
        // 1. Take off
        // 2. Landing
        // 3. Start connection
        // 4. Stop connection
    @IBAction func buttonMaster(_ sender: UIButton) {
        switch MasterButton(sender.tag) {
        case .takeoff: // `Takeoff` Button
            print("Takeoff")
        case .landing: // `Landing` Button
            print("Landing")
        case .start: // `Start` Button
            print("Start")
        case .stop: // `Stop` Button
            print("Stop")
        }
    }
    
}
