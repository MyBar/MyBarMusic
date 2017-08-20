//
//  MBMiniPlayerView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/6.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import Kingfisher

class MBMiniPlayerView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var playlistButton: UIButton!
    
    @IBOutlet weak var playOrPauseButton: UIButton!

    @IBOutlet weak var nonePlaylistLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var preMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    var currentMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    var nextMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    lazy var playerManager: MBPlayerManager = AppDelegate.delegate.playerManager
    
    private static var miniPlayerView: MBMiniPlayerView?
    
    class var shared: MBMiniPlayerView {
        
        guard self.miniPlayerView == nil else {
            return self.miniPlayerView!
        }
        
        self.miniPlayerView = Bundle.main.loadNibNamed("MBMiniPlayerView", owner: nil, options: nil)?.last as? MBMiniPlayerView
        
        self.miniPlayerView?.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        let miniPlayerViewHeight: CGFloat = 57.0
        
        let navigationBarAndStatusBarHeight: CGFloat = (UIApplication.shared.keyWindow!.rootViewController?.slideMenuController()?.mainViewController as! UINavigationController).navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        
        self.miniPlayerView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - miniPlayerViewHeight - navigationBarAndStatusBarHeight, width: UIScreen.main.bounds.width, height: miniPlayerViewHeight)
        
        self.miniPlayerView?.setupButtons()
        self.miniPlayerView?.setupScrollView()
        
        //监听状态变化
        NotificationCenter.default.addObserver(self.miniPlayerView!, selector: #selector(self.miniPlayerView!.observePlayerManagerStatus(_:)), name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        return self.miniPlayerView!
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        self.currentMiniPlayerAlbumCoverView?.pauseAnimation()
        
    }

    var isEnable: Bool = false {
        didSet {
            self.nonePlaylistLabel.isHidden = isEnable
            self.scrollView.isHidden = !isEnable
            self.playOrPauseButton.isEnabled = isEnable
            self.playlistButton.isEnabled = isEnable
            
            if isEnable == false {
                self.currentMiniPlayerAlbumCoverView?.removeAnimation()
                self.playerManager.endPlay()
            }
        }
    }
    
    private func setupButtons() {
        
        self.updatePlayOrPauseButton()
        
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_normal"), for: UIControlState.normal)
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_highlight"), for: UIControlState.highlighted)
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_disable"), for: UIControlState.disabled)
        
    }
    
    func updatePlayOrPauseButton() {
        if self.isEnable {
            if self.playerManager.isPlaying == true {
                self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_pause_normal"), for: UIControlState.normal)
                self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn"), for: UIControlState.normal)
                
                self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_pause_highlight"), for: UIControlState.highlighted)
                self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn_h"), for: UIControlState.highlighted)
                
            } else {
                self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_normal"), for: UIControlState.normal)
                self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn"), for: UIControlState.normal)
                
                self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_highlight"), for: UIControlState.highlighted)
                self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn_h"), for: UIControlState.highlighted)
            }
        } else {
            self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_disable"), for: UIControlState.disabled)
            self.playOrPauseButton.setBackgroundImage(UIImage(), for: UIControlState.disabled)
        }
    }
    
    @IBAction func clickPlayOrPauseButtonAction(_ sender: UIButton) {
        if self.isEnable {
            if self.playerManager.isPlaying == true {
                self.playerManager.pausePlay()
            } else if self.playerManager.isPlaying == false {
                self.playerManager.startPlay()
            } else if self.playerManager.playerManagerStatus == .readyToPlay {
                self.playerManager.startPlay()
            }
        }
    }
    
    private func setupScrollView() {
        
        self.scrollView.backgroundColor = self.backgroundColor
        
        let margin: CGFloat = 8.0
        
        let scrollViewWidth = UIScreen.main.bounds.width - self.playOrPauseButton.frame.width - self.playlistButton.frame.width - margin * 3

        let scrollViewHeight = self.frame.height - self.separatorView.frame.maxY
        
        self.scrollView.frame = CGRect(x: 0, y: self.separatorView.frame.maxY, width: scrollViewWidth, height: scrollViewHeight)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 3, height: self.scrollView.frame.height)
        
        self.scrollView.delegate = self
        
        self.preMiniPlayerAlbumCoverView = MBMiniPlayerAlbumCoverView.miniPlayerAlbumCoverView
        self.preMiniPlayerAlbumCoverView?.frame = CGRect(x: 0, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(self.preMiniPlayerAlbumCoverView!)
        
        self.currentMiniPlayerAlbumCoverView = MBMiniPlayerAlbumCoverView.miniPlayerAlbumCoverView
        self.currentMiniPlayerAlbumCoverView?.frame = CGRect(x: self.scrollView.frame.width, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(self.currentMiniPlayerAlbumCoverView!)
        
        self.nextMiniPlayerAlbumCoverView = MBMiniPlayerAlbumCoverView.miniPlayerAlbumCoverView
        self.nextMiniPlayerAlbumCoverView?.frame = CGRect(x: self.scrollView.frame.width * CGFloat(2), y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.addSubview(self.nextMiniPlayerAlbumCoverView!)
        
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)
        
    }
    
    /** UIScrollViewDelegate */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //关于设置一个范围因为调试的时候发现contentOffset.x有时候不是0，self.scrollView.frame.width, self.scrollView.frame.width * CGFloat(2)
        if scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= 10 {
            
            for miniPlayerAlbumCoverView in self.scrollView.subviews {
                miniPlayerAlbumCoverView.removeFromSuperview()
            }
            
            self.setupScrollView()
            
            self.playerManager.playPrevious()
        }
        
        if scrollView.contentOffset.x >= scrollView.frame.width * CGFloat(2) - 10 && scrollView.contentOffset.x <= scrollView.frame.width * CGFloat(2) + 10 {
            
            for miniPlayerAlbumCoverView in self.scrollView.subviews {
                miniPlayerAlbumCoverView.removeFromSuperview()
            }
            
            self.setupScrollView()
            
            self.playerManager.playNext()
        }
    }
}

extension MBMiniPlayerView {
    
    func observePlayerManagerStatus(_ notification: Notification) {
        
        let rotationAngle = (notification.object as? CGFloat) ?? self.currentMiniPlayerAlbumCoverView!.rotationAngle
        
        switch self.playerManager.playerManagerStatus {
        case .playing:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = playing")
            self.updatePlayOrPauseButton()
            
            self.currentMiniPlayerAlbumCoverView!.initAnimation(with: rotationAngle)
            self.currentMiniPlayerAlbumCoverView!.resumeAnimation()
            
        case .paused:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = paused")
            self.updatePlayOrPauseButton()
            
            self.currentMiniPlayerAlbumCoverView!.initAnimation(with: rotationAngle)
            self.currentMiniPlayerAlbumCoverView!.pauseAnimation()
            
        case .stopped:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = stopped")
            self.currentMiniPlayerAlbumCoverView!.removeAnimation()
            
        case .loadSongModel:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = loadSongModel")
            self.updateContentOfScrollView()
            
        case .unknown:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = unknown")
            
        case .readyToPlay:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = readyToPlay")
            self.currentMiniPlayerAlbumCoverView!.initAnimation(with: rotationAngle)
            
        case .failed:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = failed")
            
        case .none:
            print("MBMiniPlayerView.playerManager.playerManagerStatus = none")
        }
    }
    
    
    func updateContentOfScrollView() {
        var preSongInfoModelIndex = self.playerManager.currentSongInfoModelIndex! - 1
        let currentSongInfoModelIndex = self.playerManager.currentSongInfoModelIndex!
        var nextSongInfoModelIndex = self.playerManager.currentSongInfoModelIndex! + 1
        
        switch self.playerManager.playingSortType! {
            
        case MBPlayingSortType.SingleLoop:
            fallthrough
            
        case MBPlayingSortType.Sequence:
            if (preSongInfoModelIndex < 0) {
                preSongInfoModelIndex = self.playerManager.songInfoList!.count - 1
            }
            
            if (nextSongInfoModelIndex >= self.playerManager.songInfoList!.count) {
                nextSongInfoModelIndex = 0
            }
            
        case MBPlayingSortType.Random:
            if (preSongInfoModelIndex < 0) {
                preSongInfoModelIndex = self.playerManager.songInfoList!.count - 1
            }
            
            if (nextSongInfoModelIndex >= self.playerManager.songInfoList!.count) {
                nextSongInfoModelIndex = 0
            }
        }
        
        self.preMiniPlayerAlbumCoverView?.musicNameLabel.text = self.playerManager.songInfoList![preSongInfoModelIndex].title
        self.currentMiniPlayerAlbumCoverView?.musicNameLabel.text = self.playerManager.songInfoList![currentSongInfoModelIndex].title
        self.nextMiniPlayerAlbumCoverView?.musicNameLabel.text = self.playerManager.songInfoList![nextSongInfoModelIndex].title
        
        self.preMiniPlayerAlbumCoverView?.lyricLabel.text = self.playerManager.songInfoList![preSongInfoModelIndex].artist_name
        self.currentMiniPlayerAlbumCoverView?.lyricLabel.text = self.playerManager.songInfoList![currentSongInfoModelIndex].artist_name
        self.nextMiniPlayerAlbumCoverView?.lyricLabel.text = self.playerManager.songInfoList![nextSongInfoModelIndex].artist_name
        
        if let urlStr = self.playerManager.songInfoList?[preSongInfoModelIndex].pic_small {
            
            self.preMiniPlayerAlbumCoverView?.albumImageView.kf.setImage(with: URL(string: urlStr), placeholder: UIImage(named: "player_albumcover_minidefault"), options: nil, progressBlock: nil, completionHandler: nil)
            
        } else {
            self.preMiniPlayerAlbumCoverView?.albumImageView.image = UIImage(named: "player_albumcover_minidefault")
        }
        
        if let urlStr = self.playerManager.songInfoList?[currentSongInfoModelIndex].pic_small {
            
            self.currentMiniPlayerAlbumCoverView?.albumImageView.kf.setImage(with: URL(string: urlStr), placeholder: UIImage(named: "player_albumcover_minidefault"), options: nil, progressBlock: nil, completionHandler: nil)
            
        } else {
            self.currentMiniPlayerAlbumCoverView?.albumImageView.image = UIImage(named: "player_albumcover_minidefault")
        }
        
        if let urlStr = self.playerManager.songInfoList?[nextSongInfoModelIndex].pic_small {
            
            self.nextMiniPlayerAlbumCoverView?.albumImageView.kf.setImage(with: URL(string: urlStr), placeholder: UIImage(named: "player_albumcover_minidefault"), options: nil, progressBlock: nil, completionHandler: nil)
            
        } else {
            self.nextMiniPlayerAlbumCoverView?.albumImageView.image = UIImage(named: "player_albumcover_minidefault")
        }

    }

}
