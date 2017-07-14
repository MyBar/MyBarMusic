//
//  MBMiniPlayerView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/6.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMiniPlayerView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var playlistButton: UIButton!
    
    @IBOutlet weak var playOrPauseButton: UIButton!

    @IBOutlet weak var nonePlaylistLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var preMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    var currentMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    var nextMiniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView?
    
    private static var miniPlayerView: MBMiniPlayerView?
    
    class var shared: MBMiniPlayerView {
        
        if self.miniPlayerView == nil {
            self.miniPlayerView = Bundle.main.loadNibNamed("MBMiniPlayerView", owner: nil, options: nil)?.last as? MBMiniPlayerView
        }
        
        self.miniPlayerView?.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        let miniPlayerViewHeight: CGFloat = 57.0
        
        let navigationBarAndStatusBarHeight: CGFloat = (UIApplication.shared.keyWindow!.rootViewController?.slideMenuController()?.mainViewController as! UINavigationController).navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        
        self.miniPlayerView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - miniPlayerViewHeight - navigationBarAndStatusBarHeight, width: UIScreen.main.bounds.width, height: miniPlayerViewHeight)
        
        self.miniPlayerView?.setupButtons()
        self.miniPlayerView?.setupScrollView()
        
        self.miniPlayerView?.isEnable = false
        
        return self.miniPlayerView!
    }
    
    var isEnable: Bool = false {
        didSet {
            self.nonePlaylistLabel.isHidden = isEnable
            self.scrollView.isHidden = !isEnable
            self.playOrPauseButton.isEnabled = isEnable
            self.playlistButton.isEnabled = isEnable
        }
    }
    
    private func setupButtons() {
        
        self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_normal"), for: UIControlState.normal)
        self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn"), for: UIControlState.normal)
            
        self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_highlight"), for: UIControlState.highlighted)
        self.playOrPauseButton.setBackgroundImage(UIImage(named: "channel_song_list_play_btn_h"), for: UIControlState.highlighted)
        
        self.playOrPauseButton.setImage(UIImage(named: "miniplayer_btn_play_disable"), for: UIControlState.disabled)
        self.playOrPauseButton.setBackgroundImage(UIImage(), for: UIControlState.disabled)
            
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_normal"), for: UIControlState.normal)
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_highlight"), for: UIControlState.highlighted)
        self.playlistButton.setImage(UIImage(named: "miniplayer_btn_playlist_disable"), for: UIControlState.disabled)
        
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
            
            var x = preMiniPlayerAlbumCoverView!.frame.origin.x + scrollView.frame.width
            if x >= scrollView.contentSize.width {
                x = 0
            }
            preMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
            
            x += scrollView.frame.width
            if x >= scrollView.contentSize.width {
                x = 0
            }
            currentMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
            
            x += scrollView.frame.width
            if x >= scrollView.contentSize.width {
                x = 0
            }
            nextMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
        }
        
        if scrollView.contentOffset.x >= scrollView.frame.width * CGFloat(2) - 10 && scrollView.contentOffset.x <= scrollView.frame.width * CGFloat(2) + 10 {
            
            var x = preMiniPlayerAlbumCoverView!.frame.origin.x - scrollView.frame.width
            if x < 0 {
                x = scrollView.frame.width * CGFloat(2)
            }
            preMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
            
            x += scrollView.frame.width
            if x >= scrollView.contentSize.width {
                x = 0
            }
            currentMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
            
            x += scrollView.frame.width
            if x >= scrollView.contentSize.width {
                x = 0
            }
            nextMiniPlayerAlbumCoverView?.frame = CGRect(x: x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height)
        }

        scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)

    }
}
