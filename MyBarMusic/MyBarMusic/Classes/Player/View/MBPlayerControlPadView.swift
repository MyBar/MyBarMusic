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
    
    lazy var playerManager: MBPlayerManager = AppDelegate.delegate.playerManager
    
    class var playerControlPadView: MBPlayerControlPadView {
        
        let playerControlPadView = Bundle.main.loadNibNamed("MBPlayerControlPadView", owner: nil, options: nil)?.last as? MBPlayerControlPadView
        
        let playerControlPadViewHeight: CGFloat = 180
        
        playerControlPadView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - playerControlPadViewHeight, width: UIScreen.main.bounds.width, height: playerControlPadViewHeight)
        
        playerControlPadView?.setupPageControl()
        playerControlPadView?.setupTimeProgressView()
        playerControlPadView?.setupPlayControlView()
        playerControlPadView?.setupMenuView()
        
        //监听状态变化
        NotificationCenter.default.addObserver(playerControlPadView!, selector: #selector(playerControlPadView!.observePlayerManagerStatus(_:)), name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        return playerControlPadView!
    }
    
    deinit {
        print("===============playerControlPadView deinit===================")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("playerManagerStatus"), object: nil)
        
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
        
        self.updatePlayModeButton()
        
        self.updatePlayOrPauseButton()
        
        self.preButton.setBackgroundImage(UIImage(named: "player_btn_pre_normal"), for: UIControlState.normal)
        self.preButton.setBackgroundImage(UIImage(named: "player_btn_pre_highlight"), for: UIControlState.highlighted)
        
        self.nextButton.setBackgroundImage(UIImage(named: "player_btn_next_normal"), for: UIControlState.normal)
        self.nextButton.setBackgroundImage(UIImage(named: "player_btn_next_highlight"), for: UIControlState.highlighted)
    }
    
    func updatePlayOrPauseButton() {
        
        if self.playerManager.isPlaying == true {
            self.playOrPauseButton.setBackgroundImage(UIImage(named: "player_btn_pause_normal"), for: UIControlState.normal)
            self.playOrPauseButton.setBackgroundImage(UIImage(named: "player_btn_pause_highlight"), for: UIControlState.highlighted)
            
        } else {
            self.playOrPauseButton.setBackgroundImage(UIImage(named: "player_btn_play_normal"), for: UIControlState.normal)
            self.playOrPauseButton.setBackgroundImage(UIImage(named: "player_btn_play_highlight"), for: UIControlState.highlighted)

        }
    }
    
    func updatePlayModeButton() {
        switch self.playerManager.playingSortType! {
            
        case MBPlayingSortType.Sequence:
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeat_normal"), for: UIControlState.normal)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeat_highlight"), for: UIControlState.highlighted)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeat_disable"), for: UIControlState.disabled)
            
        case MBPlayingSortType.SingleLoop:
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeatone_normal"), for: UIControlState.normal)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeatone_highlight"), for: UIControlState.highlighted)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_repeatone_disable"), for: UIControlState.disabled)
            
        case MBPlayingSortType.Random:
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_random_normal"), for: UIControlState.normal)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_random_highlight"), for: UIControlState.highlighted)
            self.playModeButton.setBackgroundImage(UIImage(named: "player_btn_random_disable"), for: UIControlState.disabled)
            
        }
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
            
            self.playerManager.playPrevious()
            
        } else if sender == self.playOrPauseButton {
            
            if self.playerManager.isPlaying == true {
                self.playerManager.pausePlay()
            } else if self.playerManager.isPlaying == false {
                self.playerManager.startPlay()
            } else if self.playerManager.playerManagerStatus == .readyToPlay {
                self.playerManager.startPlay()
            }
            
        } else if sender == self.nextButton {
            
            self.playerManager.playNext()
            
        }
        
    }
    
    @IBAction func clickPlayModeButtonAction(_ sender: UIButton) {
        playerManager.switchToNextPlayingSortType { (playingSortType) in
            self.updatePlayModeButton()
        }
    }
    
}

extension MBPlayerControlPadView {
    
    func observePlayerManagerStatus(_ notification: Notification) {
        switch self.playerManager.playerManagerStatus {
        case .playing:
            print("self.playerManager.playerManagerStatus = playing")
            self.updatePlayOrPauseButton()
            
        case .paused:
            print("self.playerManager.playerManagerStatus = paused")
            self.updatePlayOrPauseButton()
            
        case .stopped:
            print("self.playerManager.playerManagerStatus = stopped")
            
        case .loadSongModel:
            print("self.playerManager.playerManagerStatus = loadSongModel")
            
        case .unknown:
            print("self.playerManager.playerManagerStatus = unknown")
            
        case .readyToPlay:
            print("self.playerManager.playerManagerStatus = readyToPlay")
            
        case .failed:
            print("self.playerManager.playerManagerStatus = failed")
            
        case .none:
            print("self.playerManager.playerManagerStatus = none")
        }
    }
    
    func refreshProgress() {
        //显示时间
        self.currentTimeLabel.text = self.convertTime(seconds: self.playerManager.playTime)
        self.totalTimeLabel.text = self.convertTime(seconds: self.playerManager.playDuration)
        
        //进度条
        self.timeProgressSlider.value = self.playerManager.progress
    }
    
    //convert Time(seconds: Float) to String(00:00)
    func convertTime(seconds: Float) -> String {
        let min = Int(seconds / 60.0)
        let sec = Int(seconds) - min * 60
        
        let minStr = min > 9 ? "\(min)" : "0\(min)"
        let secStr = sec > 9 ? "\(sec)" : "0\(sec)"
        
        return "\(minStr):\(secStr)"
        
    }
}
