//
//  MBSongListViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/16.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class MBSongListViewController: UIViewController {
    
    var songInfoList: [MBSongInfoModel]?
    
    var channelID: String?
    
    var miniPlayerView: MBMiniPlayerView?
    
    var avPlayer: AVPlayer?
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupNavigation()
        
        self.miniPlayerView = self.setupMiniPlayerView()
        
        self.fetchSongInfoList()
        
        avPlayer = AVPlayer()
    }
    
    func setupNavigation() {
        self.navigationItem.title = "歌单"
        
        let leftBarButton = UIButton(type: UIButtonType.custom)
        leftBarButton.setBackgroundImage(UIImage(named: "top_back_white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        leftBarButton.setBackgroundImage(UIImage(named: "top_back_white_pressed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        leftBarButton.frame.size = leftBarButton.currentBackgroundImage!.size
        leftBarButton.addTarget(self, action: #selector(MBSongListViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.setBackgroundImage(UIImage(named: "main_tab_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        rightBarButton.setBackgroundImage(UIImage(named: "main_tab_more_h")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        rightBarButton.frame.size = rightBarButton.currentBackgroundImage!.size
        rightBarButton.addTarget(self, action: #selector(MBSongListViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func clickNavigationBarButtonItemAction(_ sender: UIButton) {
        
        if sender == self.navigationItem.leftBarButtonItem?.customView {
            print("leftBarButtonItem")
            
            self.navigationController?.popViewController(animated: false)
            
            self.miniPlayerView?.isEnable = true
            
        } else if sender == self.navigationItem.rightBarButtonItem?.customView {
            print("rightBarButtonItem")
            
            self.miniPlayerView?.isEnable = false
        }
    }
    
    func fetchSongInfoList() {
        
        if songInfoList == nil {
            songInfoList = []
        }
        
        MBNetworkManager.fetchSongInfoList(channelID: self.channelID!, offset: songInfoList!.count) { (isSuccess, songInfoListModel) in
            
            if isSuccess == true {
                if let songList = songInfoListModel?.song_list{
                    self.songInfoList! += songList
                    
                    self.tableView.reloadData()
                }
            } else {
                
            }
        }
    }
    
}

extension MBSongListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.songInfoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCellStyle.default"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        if let songInfo = self.songInfoList?[indexPath.row] {
            cell?.textLabel?.text = songInfo.title!
        }
        
        return cell!
    }
    
}

extension MBSongListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songInfo = self.songInfoList![indexPath.row]
        
        MBNetworkManager.fetchSong(songID: songInfo.song_id!) { (isSuccess, songModel) in
            
            if isSuccess == true {
                
                if let currentItem = self.avPlayer?.currentItem {
                    currentItem.removeObserver(self, forKeyPath: "status")
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                
                let playerItem = AVPlayerItem(url: URL(string: "\(songModel!.bitrate!.file_link!)")!)
                
                self.avPlayer!.replaceCurrentItem(with: playerItem)
                self.avPlayer!.volume = 1
                
                self.avPlayer?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.playbackFinished(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem)
                
            } else {
                
            }
        }
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.avPlayer!.status {
            case AVPlayerStatus.unknown:
                print("KVO：未知状态，此时不能播放")
                
            case AVPlayerStatus.readyToPlay:
                print("KVO：准备完毕，可以播放")
                self.avPlayer!.play()
                
            case AVPlayerStatus.failed:
                print("KVO：加载失败，网络或者服务器出现问题")
            }
        }
    }
    
    func playbackFinished(_ notice: Notification) {
        
        print("播放完成")
    }
    
}
