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

//播放状态枚举值
enum MBPlayerManagerStatus {
    case none
    case failed
    case readyToPlay
    case unknown
    case loadSongModel
    case playing
    case paused
    case stopped
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
        print("===============MBPlayerManager deinit===================")
        self.removeObserverFromPlayer()
        self.removeObserverFromPlayerCurrentItem()
    }
    
    //监控时间进度
    var timeObserver: Any?
    
    //播放器
    var player: AVPlayer?
    
    //播放器播放状态
    var playerManagerStatus: MBPlayerManagerStatus = .none
    
    //是否正在播放
    var isPlaying: Bool?
    
    //是否立即播放
    var startToPlayAfterLoadingSongModel: Bool?
    
    //歌曲列表
    var songInfoList: [MBSongInfoModel]?
    
    //当前播放歌曲
    var currentSongInfoModel: MBSongInfoModel?
    
    //当前播放歌曲索引
    var currentSongInfoModelIndex: Int?
    
    //歌曲播放模式
    var playingSortType: MBPlayingSortType? = .Sequence
    
    //当前播放时间(秒)
    lazy var playTime: Float = 0.0
    
    //总时长(秒)
    lazy var playDuration: Float = 0.0
    
    //播放进度(%)
    lazy var progress: Float = 0.0
    
    
    //开始播放
    func startPlay() {
        
        self.player?.play()
    }
    
    //暂停播放
    func pausePlay() {
        
        self.player?.pause()
    }
    
    //播放完毕
    func endPlay() {
        guard (self.player != nil) else { return }
        
        //重置进度
        self.playTime = 0
        self.playDuration = 0
        self.progress = 0
        
        self.pausePlay()
        self.isPlaying = nil
        
        self.playerManagerStatus = .stopped
        NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        self.removeObserverFromPlayer()
        self.removeObserverFromPlayerCurrentItem()
        
        self.player = nil
        
    }
    
    //自然播放下一首
    func playNext() {
        
        self.endPlay()
        
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
        
        self.loadSongModel(startToPlay: true)
    }
    
    //播放上一首
    func playPrevious() {
        
        self.endPlay()
        
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
        
        self.loadSongModel(startToPlay: true)
    }
    
    //根据索引去播放一首歌曲
    func playWithIndex(_ index: Int) {
        
        self.endPlay()
        
        if (index >= self.songInfoList!.count) {
            self.currentSongInfoModelIndex = 0
        } else {
            self.currentSongInfoModelIndex = index
        }
        
        self.loadSongModel(startToPlay: true)
    }
    
    func loadSongModel(startToPlay: Bool = false) {
        
        self.currentSongInfoModel = self.songInfoList![self.currentSongInfoModelIndex!]
        
        if let file_duration = self.currentSongInfoModel?.file_duration {
            self.playDuration = Float(file_duration)!
        }
        
        MBNetworkManager.fetchSong(songID: self.currentSongInfoModel!.song_id!) { (isSuccess, songModel) in
            
            if isSuccess == true {
                
                if self.player?.currentItem != nil {
                    self.removeObserverFromPlayerCurrentItem()
                }
                
                let playerItem = AVPlayerItem(url: URL(string: "\(songModel!.bitrate!.file_link!)")!)
                
                if self.player == nil {
                    self.player = AVPlayer(playerItem: playerItem)
                    self.player?.volume = 1
                    self.addObserverToPlayer()
                } else {
                    self.player?.replaceCurrentItem(with: playerItem)
                }
                
                self.addObserverToPlayerCurrentItem()
                
                self.playerManagerStatus = .loadSongModel
                NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
                
                self.startToPlayAfterLoadingSongModel = startToPlay
                
            } else {
                
            }

        }
    }
    
    //给AVPlayer添加监控
    func addObserverToPlayer() {
        guard let player = self.player else { return }
        
        player.addObserver(self, forKeyPath: "rate", options: [.new, .old], context: nil)
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .old], context: nil)
    }
    
    //从AVPlayer移除监控
    func removeObserverFromPlayer() {
        guard let player = self.player else { return }
        
        player.removeObserver(self, forKeyPath: "rate")
        
        player.removeObserver(self, forKeyPath: "currentItem")
    }
    
    //给AVPlayerItem、AVPlayer添加监控
    func addObserverToPlayerCurrentItem() {
        
        guard let currentItem = self.player?.currentItem else { return }
        
        //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        currentItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
        
        //监控缓冲加载情况属性
        currentItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new, .old], context: nil)
        
        //监控播放完成通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.playItemDidPlayToEndTimeAction(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentItem)
        
        //监控时间进度
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            
            self?.playTime = Float(CMTimeGetSeconds(time))
            self?.playDuration = Float(CMTimeGetSeconds(currentItem.duration))
            self?.progress = (self?.playTime)! / (self?.playDuration)!
            
        })
    }
    
    //从AVPlayerItem、AVPlayer移除监控
    func removeObserverFromPlayerCurrentItem() {
        guard let currentItem = self.player?.currentItem else { return }
        
        currentItem.removeObserver(self, forKeyPath: "status")
        
        currentItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        
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
        
        if keyPath == "status" {
            
            let playerItem = object as! AVPlayerItem
            
            switch playerItem.status {
                
                case AVPlayerItemStatus.unknown:
                    print("KVO：未知状态，此时不能播放")
                    self.playerManagerStatus = .unknown
                    NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
                
                case AVPlayerItemStatus.readyToPlay:
                    print("KVO：准备完毕，可以播放")
                    self.playerManagerStatus = .readyToPlay
                    NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
                    
                    if self.startToPlayAfterLoadingSongModel == true {
                        self.startPlay()
                    }
                
                case AVPlayerItemStatus.failed:
                    print("KVO：加载失败，网络或者服务器出现问题")
                    self.playerManagerStatus = .failed
                    NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
            }
            
        } else if keyPath == "loadedTimeRanges" {
            print("KVO：loadedTimeRanges")
            
        } else if keyPath == "rate" {
            print("KVO：Rate")
            
            let rate = change![.newKey] as! Float
            
            if rate == 0 {
                self.isPlaying = false
                self.playerManagerStatus = .paused
                NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
                
            } else {
                self.isPlaying = true
                self.playerManagerStatus = .playing
                NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
            }
            
        } else if keyPath == "currentItem" {
            print("KVO：CurrentItem")
        }
    }
    
    //切换歌曲播放模式
    func switchToNextPlayingSortType(completionHandler: ((MBPlayingSortType) -> Void)? = nil ) {
        switch self.playingSortType! {
            
            case MBPlayingSortType.Sequence:
                self.playingSortType = MBPlayingSortType.SingleLoop
            
            case MBPlayingSortType.SingleLoop:
                self.playingSortType = MBPlayingSortType.Random
            
            case MBPlayingSortType.Random:
                self.playingSortType = MBPlayingSortType.Sequence
        
        }
        
        if completionHandler != nil {
            completionHandler!(self.playingSortType!)
        }
    }
    
    //从一个特定时间进度播放，progress: 0 to 1
    func seekToProgress(_ progress: Float) {
        guard self.player != nil else {
            return
        }
        
        let time = CMTime(value: CMTimeValue(progress * self.playDuration), timescale: 1)
        
        self.player!.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) { (finished) in
            self.startPlay()
        }
    }
    
}
