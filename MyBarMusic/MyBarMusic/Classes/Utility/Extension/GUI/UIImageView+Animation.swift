//
//  UIImageView+Animation.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/12.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

extension UIImageView {
        
    //初始化动画
    func initAnimationWithSpeed(_ speed: Float) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") //让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: Float.pi * speed) //旋转角度
        rotationAnimation.duration = 1.0 //旋转周期
        rotationAnimation.isCumulative = true //旋转累加角度
        rotationAnimation.repeatCount = HUGE //旋转次数
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //启动动画
    func startAnimation() {
        let pauseTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        self.layer.beginTime = timeSincePause
        
    }
    
    //暂停动画
    func pauseAnimation() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }
    
    //移除动画
    func RemoveAnimation() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
}
