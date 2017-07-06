//
//  MBMainViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMainViewController: UIViewController {
    
    var titleView: MBNavigationItemTitleView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
    }

    func setupNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "vc_head_bg"), for: UIBarMetrics.default)
        
        let leftBarButton = UIButton(type: UIButtonType.custom)
        leftBarButton.setBackgroundImage(UIImage(named: "top_tab_more"), for: UIControlState.normal)
        leftBarButton.setBackgroundImage(UIImage(named: "top_tab_more_h"), for: UIControlState.highlighted)
        leftBarButton.frame.size = leftBarButton.currentBackgroundImage!.size
        leftBarButton.addTarget(self, action: #selector(MBMainViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.setBackgroundImage(UIImage(named: "search_all"), for: UIControlState.normal)
        rightBarButton.setBackgroundImage(UIImage(named: "search_all_h"), for: UIControlState.highlighted)
        rightBarButton.frame.size = rightBarButton.currentBackgroundImage!.size
        rightBarButton.addTarget(self, action: #selector(MBMainViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.titleView = MBNavigationItemTitleView.shared
        self.titleView?.backgroundColor = UIColor(patternImage: (self.navigationController?.navigationBar.backgroundImage(for: UIBarMetrics.default))!)
        self.titleView?.myMusicLabel.text = "我的"
        self.titleView?.channelLabel.text = "音乐馆"
        self.titleView?.discoverLabel.text = "发现"
        
        let tapMyMusicLabelGestureRecognizer = UITapGestureRecognizer(target: self.titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        let tapChannelLabelGestureRecognizer = UITapGestureRecognizer(target: self.titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        let tapDiscoverLabelGestureRecognizer = UITapGestureRecognizer(target: self.titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        
        self.titleView?.myMusicLabel.isUserInteractionEnabled = true
        self.titleView?.channelLabel.isUserInteractionEnabled = true
        self.titleView?.discoverLabel.isUserInteractionEnabled = true
        
        self.titleView?.myMusicLabel.addGestureRecognizer(tapMyMusicLabelGestureRecognizer)
        self.titleView?.channelLabel.addGestureRecognizer(tapChannelLabelGestureRecognizer)
        self.titleView?.discoverLabel.addGestureRecognizer(tapDiscoverLabelGestureRecognizer)
        
        self.navigationItem.titleView = self.titleView
        
    }

    func clickNavigationBarButtonItemAction(_ sender: UIButton) {
        
        if sender == self.navigationItem.leftBarButtonItem?.customView {
            print("leftBarButtonItem")
            
        } else if sender == self.navigationItem.rightBarButtonItem?.customView {
            print("rightBarButtonItem")
        }
    }
}
