//
//  MBMiniPlayerAlbumCoverView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/6.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMiniPlayerAlbumCoverView: UIView {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var musicNameLabel: UILabel!

    @IBOutlet weak var lyricLabel: UILabel!
    
    var isAddAnimation = false
    
    class var miniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView {
        
        let miniPlayerAlbumCoverView = Bundle.main.loadNibNamed("MBMiniPlayerAlbumCoverView", owner: nil, options: nil)?.last as? MBMiniPlayerAlbumCoverView
        
        miniPlayerAlbumCoverView!.albumImageView.layer.cornerRadius = miniPlayerAlbumCoverView!.albumImageView.frame.width * 0.5;
        miniPlayerAlbumCoverView!.albumImageView.layer.masksToBounds = true
        
        miniPlayerAlbumCoverView?.backgroundColor = UIColor.clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: miniPlayerAlbumCoverView, action: #selector(MBMiniPlayerAlbumCoverView.tapAlbumCoverViewGestureRecognizer(_:)))
        
        miniPlayerAlbumCoverView?.addGestureRecognizer(tapGestureRecognizer)
        
        return miniPlayerAlbumCoverView!
    }
    
    func tapAlbumCoverViewGestureRecognizer(_ sender: UITapGestureRecognizer) {
        print("tapMiniPlayerViewGestureRecognizer")
        
        let playerViewController = MBPlayerViewController()
        
        let navViewController = UINavigationController(rootViewController: playerViewController)
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        rootVC?.present(navViewController, animated: true, completion: nil)
        
    }
    
    //初始化动画
    func initAnimationWithSpeed(_ speed: Float) {
        self.albumImageView.initAnimationWithSpeed(speed)
        self.isAddAnimation = true
    }
    
    //启动动画
    func startAnimation() {
        self.albumImageView.startAnimation()
    }
    
    //暂停动画
    func pauseAnimation() {
        self.albumImageView.pauseAnimation()
    }
    
    //移除动画
    func RemoveAnimation() {
        self.albumImageView.RemoveAnimation()
        self.isAddAnimation = false
    }
}
