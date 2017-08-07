//
//  MBPlayerManager.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/18.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import Foundation
import AVFoundation

//播放模式
enum MBPlayingSortType {
    case Sequence   // 顺序播放
    case SingleLoop // 单曲循环
    case Random     // 随机播放
    
}

class MBPlayerManager: NSObject {
    
    private static var playerManager: MBPlayerManager?
    
    class var shared: MBPlayerManager {
        if self.playerManager == nil {
            self.playerManager = MBPlayerManager()
        }
        
        return self.playerManager!
    }
    
    deinit {
        self.removeObserverFromPlayerCurrentItem()
    }
    
    //监控时间进度
    var timeObserver: Any?
    
    //播放器
    var player: AVPlayer?
    
    //歌曲列表
    var songInfoList: [MBSongInfoModel]?
    
    //当前播放歌曲
    var currentSongInfoModel: MBSongInfoModel?
    
    //当前播放歌曲索引
    var currentSongInfoModelIndex: Int?
    
    //歌曲播放模式
    var playingSortType: MBPlayingSortType?
    
    //当前播放时间(秒)
    public var playTime: CGFloat = 0.0
    
    //总时长(秒)
    public var playDuration: CGFloat = 0.0 {
        didSet {
            if playDuration != oldValue {
                
            }
        }
    }
    
    //开始播放
    func startPlay() {
        self.player?.play()
    }
    
    //暂停播放
    func pausePlay() {
        self.player?.pause()
    }
    
    //自然播放下一首
    func playNext() {
        
        switch self.playingSortType! {
            
            case MBPlayingSortType.SingleLoop:
                fallthrough
            
            case MBPlayingSortType.Sequence:
                if (self.currentSongInfoModelIndex! + 1 >= self.songInfoList!.count) {
                    self.currentSongInfoModelIndex = 0
                } else {
                    self.currentSongInfoModelIndex = self.currentSongInfoModelIndex! + 1
                }
            
            case MBPlayingSortType.Random:
                if (self.currentSongInfoModelIndex! + 1 >= self.songInfoList!.count) {
                    self.currentSongInfoModelIndex = 0
                } else {
                    self.currentSongInfoModelIndex = self.currentSongInfoModelIndex! + 1
                }
        }
        
        self.loadSongModel()
        self.startPlay()
    }
    
    //播放上一首
    func playPrevious() {
        
        switch self.playingSortType! {
            
            case MBPlayingSortType.SingleLoop:
                fallthrough
            
            case MBPlayingSortType.Sequence:
                if (self.currentSongInfoModelIndex! - 1 < 0) {
                    self.currentSongInfoModelIndex = self.songInfoList!.count - 1
                } else {
                    self.currentSongInfoModelIndex = self.currentSongInfoModelIndex! - 1
                }
            
            case MBPlayingSortType.Random:
                if (self.currentSongInfoModelIndex! - 1 < 0) {
                    self.currentSongInfoModelIndex = self.songInfoList!.count - 1
                } else {
                    self.currentSongInfoModelIndex = self.currentSongInfoModelIndex! - 1
                }
        }
        
        self.loadSongModel()
        self.startPlay()
    }
    
    //根据索引去播放一首歌曲
    func playWithIndex(_ index: Int) {
        if (index >= self.songInfoList!.count) {
            self.currentSongInfoModelIndex = 0
        } else {
            self.currentSongInfoModelIndex = index
        }
        
        self.loadSongModel()
        self.startPlay()
    }
    
    func loadSongModel() {
        
        self.currentSongInfoModel = self.songInfoList![self.currentSongInfoModelIndex!]
        
        MBNetworkManager.fetchSong(songID: self.currentSongInfoModel!.song_id!) { (isSuccess, songModel) in
            
            if isSuccess == true {
                
                if self.player?.currentItem != nil {
                    self.removeObserverFromPlayerCurrentItem()
                }
                
                let playerItem = AVPlayerItem(url: URL(string: "\(songModel!.bitrate!.file_link!)")!)
                
                if self.player == nil {
                    self.player = AVPlayer(playerItem: playerItem)
                } else {
                    self.player?.replaceCurrentItem(with: playerItem)
                }
                
                self.player?.volume = 1
                
                self.addObserverToPlayerCurrentItem()
                
            } else {
                
            }

        }
    }
    
    //给AVPlayerItem、AVPlayer添加监控
    func addObserverToPlayerCurrentItem() {
        //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
        //监控缓冲加载情况属性
        self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        
        //监控播放完成通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.playItemDidPlayToEndTimeAction(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            
            self?.playTime = CGFloat(CMTimeGetSeconds(time))
            self?.playDuration = CGFloat(CMTimeGetSeconds(self!.player!.currentItem!.duration))
            
            
            
        })
    }
    
    //从AVPlayerItem、AVPlayer移除监控
    func removeObserverFromPlayerCurrentItem() {
        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
        
        self.player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        if self.timeObserver != nil {
            self.player?.removeTimeObserver(self.timeObserver!)
            self.timeObserver = nil
        }
    }
    
    //AVPlayerItem播放完成后动作
    func playItemDidPlayToEndTimeAction(_ notification: Notification) {
        print("播放完成")
        
        self.playNext()
    }
    
    /**
     *  通过KVO监控播放器状态
     *
     *  @param keyPath 监控属性
     *  @param object  监视器
     *  @param change  状态改变
     *  @param context 上下文
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let playerItem = object as! AVPlayerItem
        
        if keyPath == "status" {
            switch self.player!.status {
            case AVPlayerStatus.unknown:
                print("KVO：未知状态，此时不能播放")
                
            case AVPlayerStatus.readyToPlay:
                print("KVO：准备完毕，可以播放")
                
                self.startPlay()
                
            case AVPlayerStatus.failed:
                print("KVO：加载失败，网络或者服务器出现问题")
            }
        } else if keyPath == "loadedTimeRanges" {
            
        }
    }
    
    //切换歌曲播放模式
    func switchToNextPlayingSortType() {
        switch self.playingSortType! {
            
            case MBPlayingSortType.Sequence:
                self.playingSortType = MBPlayingSortType.SingleLoop
            
            case MBPlayingSortType.SingleLoop:
                self.playingSortType = MBPlayingSortType.Random
            
            case MBPlayingSortType.Random:
                self.playingSortType = MBPlayingSortType.Sequence
        
        }
    }
    
}
