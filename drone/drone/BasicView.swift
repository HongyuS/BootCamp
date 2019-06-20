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
        distanceSliderValue.text = "\(distanceSlider.value)"
        rotateAngle.text = "\(rotateAngleSlider.value)"
        
    }
    
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
    
}

