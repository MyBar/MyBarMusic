//
//  MBSettingViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/14.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBSettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["仅Wi-Fi联网", "定时关闭", "免流量服务", "传歌到手机", "QPlay与车载音乐", "清理占用空间", "帮助与反馈", "关于麦霸音乐"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MBSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            let identifier = "MBSwitchTableViewCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSwitchTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "MBSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSwitchTableViewCell
            }
            
            cell?.backgroundColor = UIColor.clear
            cell?.indexPath = indexPath
            cell?.textLabel?.text = self.menus[indexPath.row]
            cell?.switchControl.isOn = (indexPath.row == 0 ? true : false)
            
            return cell!
            
        } else if indexPath.row == 2 {
            let identifier = "TableViewCellStyle.value1"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
            }
            
            cell?.backgroundColor = UIColor.clear
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.textLabel?.text = self.menus[indexPath.row]
            cell?.detailTextLabel?.text = "在线听歌免流量"
            
            return cell!
            
        } else {
            let identifier = "TableViewCellStyle.default"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            }
            
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.text = self.menus[indexPath.row]
            
            return cell!
        }
    }
}

extension MBSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
