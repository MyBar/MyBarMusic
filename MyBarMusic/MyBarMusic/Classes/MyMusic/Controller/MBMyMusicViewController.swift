//
//  MBMyMusicViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/24.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MBMyMusicViewController: UIViewController {

    @IBOutlet weak var warningBannerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.setupWarningBannerView()
        
        //监听网络状态变化
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkReachabilityStatusChanged(_:)), name: NSNotification.Name("NetworkReachabilityStatus"), object: nil)
    }

    func setupWarningBannerView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MBMyMusicViewController.tapWarningBannerViewAction(_:)))
        
        self.warningBannerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tapWarningBannerViewAction(_ sender: UITapGestureRecognizer) {
        print("========Tap warningBannerView======")
    }
    
    @IBAction func clickCloseButtonOfWarningBannerView(_ sender: UIButton) {
        var frame = self.tableView.frame
        frame.origin.y = frame.origin.y - self.warningBannerView.frame.height
        frame.size.height = frame.size.height + self.warningBannerView.frame.height
        self.tableView.frame = frame
        
        self.warningBannerView.isHidden = true
    }

}

extension MBMyMusicViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCellStyle.default"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        cell?.textLabel?.text = "\(indexPath.row)"
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                
                let identifier = "MBLoginTableViewCell"
                
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBLoginTableViewCell
                
                if cell == nil {
                    tableView.register(UINib(nibName: "MBLoginTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBLoginTableViewCell
                    
                    cell?.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
                    cell?.selectionStyle = .none
                }
                
                cell?.userCoverImageView.image = UIImage(named: "default_user_156")
                cell?.usernameLabel.text = "—  座谈砖家  —"
                
                return cell!
                
            } else if indexPath.row == 1 {
                let identifier = "MBMyMusicTableViewCell"
                
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBMyMusicTableViewCell
                
                if cell == nil {
                    tableView.register(UINib(nibName: "MBMyMusicTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBMyMusicTableViewCell
                    
                    cell?.selectionStyle = .none
                }
                
                return cell!
            }
            
        case 1:
            
            let identifier = "MBRadioTableViewCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBRadioTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "MBRadioTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBRadioTableViewCell
            }

            if indexPath.row == 0 {
                
                cell?.albumImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "vc_head_bg"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.centerImageView.image = UIImage(named: "mymusic_guess_like_play")
                cell?.radioLabel.text = "个性电台"
                cell?.radioDescribeLabel.text = "好音乐因你而存在"
                
                return cell!
            } else {
                
                cell?.albumImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "vc_head_bg"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.centerImageView.image = UIImage(named: "mymusic_guess_like_play")
                cell?.radioLabel.text = "跑步电台"
                cell?.radioDescribeLabel.text = "QQ音乐 x Nike，让运动乐在其中"
                
                return cell!
            }
            
        case 2:
            if indexPath.row == 0 {
                let identifier = "MBSongListManageTableViewCell"
                
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSongListManageTableViewCell
                
                if cell == nil {
                    tableView.register(UINib(nibName: "MBSongListManageTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSongListManageTableViewCell
                    
                    cell?.selectionStyle = .none
                }
                
                cell?.selfBuildSongListNumLabel.text = ""
                cell?.collectionSongListNumLabel.text = ""
                
                return cell!
            } else {
                let identifier = "MBSongListTableViewCell"
                
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSongListTableViewCell
                
                if cell == nil {
                    tableView.register(UINib(nibName: "MBSongListTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MBSongListTableViewCell
                }
                
                if indexPath.row == 1 {
                    cell!.albumImageView.image = UIImage(named: "mymusic_root_empty_folder")
                    cell!.songListContainerView.isHidden = true
                }
                
                return cell!
            }
            
        default:
            if indexPath.row == 0 {
                
            } else {
                
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 6
        case 2:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 112.0
            } else if indexPath.row == 1 {
                return 212.0
            }
            
        case 1:
            return 64.0
            
        case 2:
            if indexPath.row == 0 {
                return 56.0
            } else {
                return 64.0
            }
            
        default:
            return 64.0
        }
        
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case 0:
            print("\(indexPath)")
        case 1:
            print("\(indexPath)")
        case 2:
            if indexPath.row == 0 {
                //var cell = tableView.cellForRow(at: indexPath) as? MBSongListManageTableViewCell
                
                
            } else {
                
            }
        default:
            print("\(indexPath)")
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let scrollView = self.view.superview as? UIScrollView
        if indexPath.section == 1 && indexPath.row == 1 {
            scrollView?.isScrollEnabled = false
        } else {
            scrollView?.isScrollEnabled = true
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == 1
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let scrollView = self.view.superview as? UIScrollView
        scrollView?.isScrollEnabled = true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            let editingRowAction = UITableViewRowAction(style: .destructive, title: "删除", handler: { (editingRowAction, indexPath) in
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            })
            
            return [editingRowAction]
            
        } else {
            return nil
        }
    }
}


extension MBMyMusicViewController {
    func networkReachabilityStatusChanged(_ notification: Notification) {
        let isReachable = MBNetworkReachabilityStatusListener.shared.networkReachabilityManager?.isReachable ?? false
        
        if isReachable {
            var frame = self.tableView.frame
            frame.origin.y = frame.origin.y - self.warningBannerView.frame.height
            frame.size.height = frame.size.height + self.warningBannerView.frame.height
            self.tableView.frame = frame
            
            self.warningBannerView.isHidden = true
        } else {
            var frame = self.tableView.frame
            frame.origin.y = frame.origin.y + self.warningBannerView.frame.height
            frame.size.height = frame.size.height - self.warningBannerView.frame.height
            self.tableView.frame = frame
            
            self.warningBannerView.isHidden = false
        }
    }
}
