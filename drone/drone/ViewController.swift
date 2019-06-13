//
//  ViewController.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/13.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        distanceSliderValue.text = "\(distanceSlider.value)"
        rotateAngle.text = "\(rotateAngleSlider.value)"
    }

    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSliderValue: UILabel!
    @IBAction func distanceSliderValueChange(_ sender: UISlider) {
        distanceSliderValue.text = "\(sender.value)"
    }
    
    @IBOutlet weak var rotateAngleSlider: UISlider!
    @IBOutlet weak var rotateAngle: UILabel!
    @IBAction func rotateAngleSliderValueChange(_ sender: UISlider) {
        rotateAngle.text = "\(sender.value)"
    }
    
    @IBOutlet weak var droneState: UILabel!
    @IBOutlet weak var udpState: UILabel!
    @IBOutlet weak var aliveState: UILabel!
    
}

