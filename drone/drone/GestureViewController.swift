//
//  GestureViewController.swift
//  drone
//
//  Created by Hongyu Shi on 2019/6/24.
//  Copyright © 2019 HY S. All rights reserved.
//

import UIKit
import VideoToolbox

class GestureViewController: UIViewController {
    
    private var mgr = DroneManager()
    private var frameDecoder: VideoFrameDecoder!
    
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
    
    @IBOutlet weak var ssid: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var touchPad: UIView!
    @IBOutlet weak var videoView: UIImageView!
    
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
        
        // Create video decoder.
        VideoFrameDecoder.delegate = self
        frameDecoder = VideoFrameDecoder()
        
    }
    
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
//            self.mgr.streamoff()
            resetStatus()
            self.mgr.stop()
        }
    }
    
    @IBAction func setWifi(_ sender: UIButton) {
        guard let ssid_text = ssid.text else { return }
        guard ssid_text != "" else { return }
        mgr.renameWifi(ssid: ssid_text, pass: pass.text ?? "")
        ssid.text = nil
        pass.text = nil
    }
    
    @IBAction func videoButton(_ sender: UIButton) {
        Global.animateButton(sender)
        
        guard connectionStatus.text! == "Ready" else { return }
        
        switch VideoButton(sender.tag) {
        case .stream_on:
            self.mgr.streamon()
            self.startStreamServer()
        case .stream_off:
            self.mgr.streamoff()
        }
    }
    
}


// MARK: Private Functions
extension GestureViewController {
    
    private func addGesture() {
        
        let dir: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for d in dir {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(singleFingerSwipe(_:)))
            swipe.direction = d
            swipe.numberOfTouchesRequired = 1
            touchPad.addGestureRecognizer(swipe)
        }
        
        for d in dir[0...1] {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(doubleFingerSwipe(_:)))
            swipe.direction = d
            swipe.numberOfTouchesRequired = 2
            touchPad.addGestureRecognizer(swipe)
        }
        
    }
    
    // Single finger Swipe Gesture actions.
    @objc private func singleFingerSwipe(_ sender: UISwipeGestureRecognizer) {
        switch flipSwitch.isOn {
        case true:
            switch sender.direction {
            case .up: self.mgr.flip(inDirection: .forward)
            case .down: self.mgr.flip(inDirection: .back)
            case .left: self.mgr.flip(inDirection: .left)
            case .right: self.mgr.flip(inDirection: .right)
            default: return
            }
        default:
            switch sender.direction {
            case .up:
                self.mgr.move(inDirection: .forward, withDistance: distanceSliderValue.text ?? "50")
            case .down:
                self.mgr.move(inDirection: .back, withDistance: distanceSliderValue.text ?? "50")
            case .left:
                self.mgr.move(inDirection: .left, withDistance: distanceSliderValue.text ?? "50")
            case .right:
                self.mgr.move(inDirection: .right, withDistance: distanceSliderValue.text ?? "50")
            default: return
            }
        }
    }
    
    // Single finger Swipe Gesture actions.
    @objc private func doubleFingerSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            self.mgr.move(inDirection: .up, withDistance: distanceSliderValue.text ?? "50")
        case .down:
            self.mgr.move(inDirection: .down, withDistance: distanceSliderValue.text ?? "50")
        default: return
        }
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
    
    func onVideoDataArrival(data: Array<UInt8>) {
        print(#function, data.count)
        /*
        DispatchQueue.global(qos: .userInteractive).async {
            var currentImg: [UInt8] = []
            
            currentImg = currentImg + data
            
            if data.count < 1460 && currentImg.count > 40 {
                print("video received")
                self.frameDecoder.interpretRawFrameData(&currentImg)
                currentImg = []
            }
            
        }
         */
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


// MARK: VideoFrameDecoderDelegate
// Show video in Video View
extension GestureViewController: VideoFrameDecoderDelegate {
    
    internal func receivedDisplayableFrame(_ frame: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            DispatchQueue.main.async {
                self.videoView.image = UIImage(cgImage: cgImage)
            }
        } else {
            print("Fail")
        }
    }
    
}
