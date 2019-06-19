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
    
    // Master Button outlet.
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Distance Slider outlet and action to change value label.
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSliderValue: UILabel!
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        distanceSliderValue.text = "\(sender.value)"
    }
    
    // Rotation Angle Slider outlet and action to change value label.
    @IBOutlet weak var rotateAngleSlider: UISlider!
    @IBOutlet weak var rotateAngle: UILabel!
    @IBAction func rotateAngleSliderValueChange(_ sender: UISlider) {
        rotateAngle.text = "\(sender.value)"
    }
    
    // Drone Status labels.
    @IBOutlet weak var timeStatus: UILabel!
    @IBOutlet weak var heightStatus: UILabel!
    @IBOutlet weak var batteryStatus: UIProgressView!
    @IBOutlet weak var droneStatus: UILabel!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var aliveStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // "Do any additional setup after loading the view."
        
        // Set corner radius of buttons.
        startButton.layer.cornerRadius = 8
        stopButton.layer.cornerRadius = 8
        
        // Initialize label values of sliders.
        distanceSliderValue.text = "\(distanceSlider.value)"
        rotateAngle.text = "\(rotateAngleSlider.value)"
        
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
        if mode.selectedSegmentIndex == 0 {
            // `Horizontal` Mode
            switch sender.tag {
            case 0: // `Forward` Button
                print("Move Forward")
            case 1: // `Bcak` Button
                print("Move Back")
            case 2: // `Left` Button
                print("Move Left")
            case 3: // `Right` Button
                print("Move Right")
            default:
                print(#function, mode.selectedSegmentIndex)
            }
        } else {
            // `Vertical` Mode
            switch sender.tag {
            case 0: // `Up` Button
                print("Move Up")
            case 1: // `Down` Button
                print("Move Down")
            case 2: // `Left` Button (Rotate)
                print("Rotate Left")
            case 3: // `Right` Button (Rotate)
                print("Rotate Right")
            default:
                print(#function, mode.selectedSegmentIndex)
            }
        }
    }
    
    // Swipe Gesture actions:
        // UP: flip forward;
        // DOWN: flip back;
        // LEFT: flip left;
        // RIGHT: flip right.
    @IBAction func flipControl(_ sender: UISwipeGestureRecognizer) {
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
    
    // Master Button actions:
        // 1. Take off
        // 2. Landing
        // 3. Start connection
        // 4. Stop connection
    @IBAction func buttonMaster(_ sender: UIButton) {
        switch sender.tag {
        case 0: // `Takeoff` Button
            print("Takeoff")
        case 1: // `Landing` Button
            print("Landing")
        case 2: // `Start` Button
            print("Start")
        case 3: // `Stop` Button
            print("Stop")
        default:
            print(#function)
        }
    }
    
}
