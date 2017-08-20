//
//  RotationAnimationImageView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/19.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class RotationAnimationImageView: UIImageView {

    var rotationAngle: CGFloat = 0
    
    private var timer: Timer?
    
    func initAnimation(with rotationAngle: CGFloat = 0.0) {
        self.rotationAngle = rotationAngle
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func resumeAnimation() {
        self.addTimer()
    }
    
    func pauseAnimation() {
        self.removeTimer()
    }
    
    func removeAnimation() {
        self.rotationAngle = 0.0
        self.removeTimer()
        self.transform = CGAffineTransform.identity
    }
    
    private func addTimer() {
        guard self.timer == nil else {
            return
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / 20.0, target: self, selector: #selector(self.refreshUI), userInfo: nil, repeats: true)
        
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
        
    }
    
    private func removeTimer() {
        guard self.timer != nil else {
            return
        }
        
        self.timer?.invalidate()
        self.timer = nil
        
    }
    
    func refreshUI() {
        
        rotationAngle += 0.01
        
        if rotationAngle >= CGFloat(Float.pi * 2.0) {
            rotationAngle = 0
        }
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        self.transform = transform
    }
    


}
