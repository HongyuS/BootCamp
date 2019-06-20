//
//  BasicView.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/13.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class BasicView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialize label values of sliders.
        Global.updateLabel(distanceSliderValue, withValue: "\(Int(distanceSlider.value))")
        Global.updateLabel(rotateAngle, withValue: "\(Int(rotateAngleSlider.value))")
        
    }
    
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
    
}

// MARK: Actions of buttons.
extension BasicView {
    
    // Move Button actions.
    @IBAction func buttonMove(_ sender: UIButton) {
        switch MoveDirection(sender.tag) {
        case .forward: // `Forward` Button
            print("Move Forward")
        case .back: // `Bcak` Button
            print("Move Back")
        case .left: // `Left` Button
            print("Move Left")
        case .right: // `Right` Button
            print("Move Right")
        case .up: // `Up` Button
            print("Move Up")
        case .down: // `Down` Button
            print("Move Down")
        }
    }
    
    // Rotate Button actions.
    @IBAction func buttonRotate(_ sender: UIButton) {
        switch RotateDirection(sender.tag) {
        case .ccw: // `CCW` Button
            print("Rotate Left")
        case .cw: // `CW` Button
            print("Rotate Right")
        }
    }
    
    // Flip Button actions.
    @IBAction func flipControl(_ sender: UIButton) {
        switch FlipDirection(sender.tag) {
        case .forward: // Click `Flip Forward` button on the screen.
            print("Flip FORWARD")
        case .back: // Click `Flip Back` button on the screen.
            print("Flip BACK")
        case .left: // Click `Flip Left` button on the screen.
            print("Flip LEFT")
        case .right: // Click `Flip Right` button on the screen.
            print("Flip RIGHT")
        }
    }
    
    // Master Button actions.
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
