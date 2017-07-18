//
//  MBChannelViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/16.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBChannelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let channelMenus = ["1":"新歌榜","2":"热歌榜","7":"叱咤", "8":"公告牌", "11":"摇滚榜","12":"爵士", "14":"影视金曲", "16":"流行", "18":"Hito中文榜", "20":"华语金曲","21":"欧美金曲榜","22":"经典老歌榜","23":"情歌对唱榜","24":"影视金曲榜","25":"网络歌曲榜"]
    var channelKeys: [String]?
    var channelValues: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.channelKeys = Array(channelMenus.keys)
        self.channelValues = Array(channelMenus.values)
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MBChannelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.channelMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCellStyle.default"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        cell?.textLabel?.text = self.channelValues?[indexPath.row]
        
        return cell!
    }
    
}

extension MBChannelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songlistVC = MBSongListViewController()
        songlistVC.channelID = self.channelKeys![indexPath.row]
        
        guard let navVC = self.view.window?.rootViewController?.slideMenuController()?.mainViewController as? UINavigationController else { return }
        
        navVC.pushViewController(songlistVC, animated: false)
        
    }
    
}
