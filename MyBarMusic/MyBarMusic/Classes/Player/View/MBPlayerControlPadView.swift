//
//  MBPlayerView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/9.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBPlayerControlPadView: UIView {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeProgressSlider: UISlider!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var playModeButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var playerAlbumCoverView: MBPlayerAlbumCoverView?
    
    class var playerControlPadView: MBPlayerControlPadView {
        
        let playerControlPadView = Bundle.main.loadNibNamed("MBPlayerControlPadView", owner: nil, options: nil)?.last as? MBPlayerControlPadView
        
        let playerControlPadViewHeight: CGFloat = 180
        
        playerControlPadView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - playerControlPadViewHeight, width: UIScreen.main.bounds.width, height: playerControlPadViewHeight)
        
        playerControlPadView?.setupPageControl()
        playerControlPadView?.setupTimeProgressView()
        playerControlPadView?.setupPlayControlView()
        playerControlPadView?.setupMenuView()
        
        return playerControlPadView!
    }
    
    func setupPageControl() {
        self.pageControl.isEnabled = false
    }

    func setupTimeProgressView() {
        // 滑块颜色
        self.timeProgressSlider.thumbTintColor = UIColor(patternImage: UIImage(named: "player_slider_playback_thumb")!)
        // 将滑块赋图片 图片的大小就是显示的大小
        // 通常状态下
        self.timeProgressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        // 滑动状态下
        self.timeProgressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.highlighted)
        
        // 走过的进度条的颜色
        self.timeProgressSlider.minimumTrackTintColor = UIColor(patternImage: UIImage(named: "player_slider_playback_left")!)
        // 未走过的进度条的颜色
        self.timeProgressSlider.maximumTrackTintColor = UIColor(patternImage: UIImage(named: "player_slider_playback_right")!)
    }
    
    func setupPlayControlView() {
        
        self.preButton.setBackgroundImage(UIImage(named: "player_btn_pre_normal"), for: UIControlState.normal)
        self.preButton.setBackgroundImage(UIImage(named: "player_btn_pre_highlight"), for: UIControlState.highlighted)
        
        self.nextButton.setBackgroundImage(UIImage(named: "player_btn_next_normal"), for: UIControlState.normal)
        self.nextButton.setBackgroundImage(UIImage(named: "player_btn_next_highlight"), for: UIControlState.highlighted)
    }

    func setupMenuView() {
        
        self.shareButton.setBackgroundImage(UIImage(named: "player_btn_share_normal"), for: UIControlState.normal)
        self.shareButton.setBackgroundImage(UIImage(named: "player_btn_share_highlight"), for: UIControlState.highlighted)
        self.shareButton.setBackgroundImage(UIImage(named: "player_btn_share_disable"), for: UIControlState.disabled)
        
        self.commentButton.setBackgroundImage(UIImage(named: "player_btn_favorite_normal"), for: UIControlState.normal)
        self.commentButton.setBackgroundImage(UIImage(named: "player_btn_favorite_highlight"), for: UIControlState.highlighted)
        self.commentButton.setBackgroundImage(UIImage(named: "player_btn_favorite_disable"), for: UIControlState.disabled)
    }
    
    func updatePageControlCurrentPage(_ currentPage: Int) {
        self.pageControl.currentPage = currentPage
    }
    
    @IBAction func clickPlayControlButtonAction(_ sender: UIButton) {
        
        if sender == self.preButton {
            self.playerAlbumCoverView?.albumCoverImageView.RemoveAnimation()
            self.playerAlbumCoverView?.albumCoverImageView.initAnimationWithSpeed(0.1)
            self.playerAlbumCoverView?.albumCoverImageView.startAnimation()
        } else if sender == self.playOrPauseButton {
            self.playerAlbumCoverView?.albumCoverImageView.pauseAnimation()
            
        } else if sender == self.nextButton {
            self.playerAlbumCoverView?.albumCoverImageView.RemoveAnimation()
            self.playerAlbumCoverView?.albumCoverImageView.initAnimationWithSpeed(0.2)
            self.playerAlbumCoverView?.albumCoverImageView.startAnimation()
        }
        
    }
    
}
