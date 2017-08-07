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
    
    var songInfoListModel: MBSongInfoListModel?
    
    var channelID: String?
    
    var miniPlayerView: MBMiniPlayerView?
    
    lazy var playerManager: MBPlayerManager = AppDelegate.delegate.playerManager

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupNavigation()
        
        self.miniPlayerView = self.setupMiniPlayerView()
        
        self.fetchSongInfoList()
        
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
        MBNetworkManager.fetchSongInfoList(channelID: self.channelID!, offset: self.songInfoListModel?.song_list?.count) { (isSuccess, songInfoListModel) in
            
            if isSuccess == true {
                
                if (self.songInfoListModel == nil) || (self.songInfoListModel!.billboard?.billboard_type != songInfoListModel!.billboard?.billboard_type) {
                    self.songInfoListModel = songInfoListModel
                } else if self.songInfoListModel!.billboard?.billboard_type == songInfoListModel!.billboard?.billboard_type {
                    
                    if let songList = songInfoListModel?.song_list{
                        self.songInfoListModel!.song_list! += songList
                    }
                }
                
                self.tableView.reloadData()
                
            } else {
                
            }
        }
    }
    
}

extension MBSongListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.songInfoListModel?.song_list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCellStyle.default"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        if let songInfo = self.songInfoListModel?.song_list?[indexPath.row] {
            cell?.textLabel?.text = songInfo.title!
        }
        
        return cell!
    }
    
}

extension MBSongListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (playerManager.songInfoList == nil) || (playerManager.songInfoList!.count != self.songInfoListModel!.song_list!.count ) {
            
            playerManager.songInfoList = self.songInfoListModel!.song_list!
            playerManager.currentSongInfoModelIndex = indexPath.row
            playerManager.loadSongModel()
            
        } else if (playerManager.songInfoList!.elementsEqual(self.songInfoListModel!.song_list!, by: { (songInfoModel1, songInfoModel2) -> Bool in
            return songInfoModel1.song_id! == songInfoModel2.song_id!
        })) {
            
            if playerManager.currentSongInfoModelIndex != indexPath.row {
                playerManager.currentSongInfoModelIndex = indexPath.row
                playerManager.loadSongModel()
            }
        } else {
            playerManager.songInfoList = self.songInfoListModel!.song_list!
            playerManager.currentSongInfoModelIndex = indexPath.row
            playerManager.loadSongModel()
        }
        
        playerManager.startPlay()
        
        let playerViewController = MBPlayerViewController()
        let navViewController = UINavigationController(rootViewController: playerViewController)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(navViewController, animated: true, completion: nil)
        
        print("\(indexPath.row)")
        print("\(playerManager.songInfoList!.count)")
    }
    
}
