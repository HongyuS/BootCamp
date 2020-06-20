//
//  UIVideoView.swift
//  drone-swiftUI
//
//  Created by Hongyu Shi on 2020/6/19.
//  Copyright © 2020 Hongyu Shi. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VideoView: View {
    
    var videoLayer = AVSampleBufferDisplayLayer()
    var mgr: DroneManager

    let decoder = VideoDecoder()
        
    var body: some View {
        UIVideoView(videoLayer: videoLayer, mgr: mgr)
            .onAppear {
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(2))) {
                    // use either startHandle() or decoder.renderVideoStream(),
                    // they just behave in different ways, but eventually the same, giving more flexibility
                    print("Decode video")
                    self.decoder.renderVideoStream(streamBuffer: &self.mgr.drone.streamBuffer, to: self.videoLayer)
                }
        }
    }
}

struct UIVideoView: UIViewRepresentable {
    
    var videoLayer: AVSampleBufferDisplayLayer

    var mgr: DroneManager
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ view: UIView, context: Context) {
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let _CMTimebasePointer = UnsafeMutablePointer<CMTimebase?>.allocate(capacity: 1)
        let status = CMTimebaseCreateWithMasterClock( allocator: kCFAllocatorDefault, masterClock: CMClockGetHostTimeClock(),  timebaseOut: _CMTimebasePointer )
        videoLayer.controlTimebase = _CMTimebasePointer.pointee
        
        if let controlTimeBase = videoLayer.controlTimebase, status == noErr {
            CMTimebaseSetTime(controlTimeBase, time: CMTime.zero);
            CMTimebaseSetRate(controlTimeBase, rate: 1.0);
        }
        
        view.layer.addSublayer(videoLayer)
//        view.layer.display()
    }
}

/*class VideoLayerView: UIView {
    var videoLayer: AVSampleBufferDisplayLayer
//    var videoLayer: AVSampleBufferDisplayLayer {
//        return layer as! AVSampleBufferDisplayLayer
//    }

    var mgr: DroneManager
    
    override class var layerClass: AnyClass {
        return AVSampleBufferDisplayLayer.self
    }
    
    init(videoLayer: AVSampleBufferDisplayLayer, mgr: DroneManager) {
        self.videoLayer = videoLayer
        self.mgr = mgr
        self.layer.addSublayer(videoLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}*/
