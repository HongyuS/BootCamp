//
//  PlusView.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/17.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit

class PlusView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        upButton.layer.cornerRadius = 32
        downButton.layer.cornerRadius = 32
        leftButton.layer.cornerRadius = 32
        rightButton.layer.cornerRadius = 32
        
        distanceSliderValue.text = "\(distanceSlider.value)"
        rotateAngle.text = "\(rotateAngleSlider.value)"
        
    }
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
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
    
}
