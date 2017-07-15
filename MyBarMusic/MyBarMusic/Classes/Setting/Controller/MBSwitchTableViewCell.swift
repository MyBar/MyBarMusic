//
//  MBSwitchTableViewCell.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/14.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchControl: UISwitch!
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChangeAction(_ sender: UISwitch) {
        let settingVC = UIApplication.shared.keyWindow?.rootViewController?.slideMenuController()?.leftViewController as! MBSettingViewController
        
        if indexPath.row == 0 {
            if sender.isOn == false {
                let alert = UIAlertController(title: nil, message: "已关闭Wi-Fi联网，2G/3G/4G网络功能请关注流量消耗", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertActionStyle.cancel, handler: nil))
                
                settingVC.present(alert, animated: true, completion: nil)
            }
            
        } else {
            if sender.isOn == true {
                let indexPath = IndexPath(row: self.indexPath.row + 1, section: self.indexPath.section)
                
                settingVC.menus.insert("自定义", at: indexPath.row)
                settingVC.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } else {
                let indexPath = IndexPath(row: self.indexPath.row + 1, section: self.indexPath.section)
                
                settingVC.menus.remove(at: indexPath.row)
                settingVC.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
        
    }
}
