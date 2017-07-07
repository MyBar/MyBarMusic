//
//  MBMainViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMainViewController: UIViewController {
    
    var miniPlayerView: MBMiniPlayerView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        self.setupNavigation()
        
        self.setupMiniPlayerView()
    }
    
    func setupMiniPlayerView() {
        self.miniPlayerView = MBMiniPlayerView.shared
        
        self.miniPlayerView?.isEnable = false
        
        self.view.addSubview(self.miniPlayerView!)
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
        
        let titleView = MBNavigationItemTitleView.shared
        titleView.backgroundColor = UIColor(patternImage: (self.navigationController?.navigationBar.backgroundImage(for: UIBarMetrics.default))!)
        titleView.myMusicLabel.text = "我的"
        titleView.channelLabel.text = "音乐馆"
        titleView.discoverLabel.text = "发现"
        
        let tapMyMusicLabelGestureRecognizer = UITapGestureRecognizer(target: titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        let tapChannelLabelGestureRecognizer = UITapGestureRecognizer(target: titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        let tapDiscoverLabelGestureRecognizer = UITapGestureRecognizer(target: titleView, action: #selector(MBNavigationItemTitleView.tapGestureRecognizerAction(_:)))
        
        titleView.myMusicLabel.isUserInteractionEnabled = true
        titleView.channelLabel.isUserInteractionEnabled = true
        titleView.discoverLabel.isUserInteractionEnabled = true
        
        titleView.myMusicLabel.addGestureRecognizer(tapMyMusicLabelGestureRecognizer)
        titleView.channelLabel.addGestureRecognizer(tapChannelLabelGestureRecognizer)
        titleView.discoverLabel.addGestureRecognizer(tapDiscoverLabelGestureRecognizer)
        
        self.navigationItem.titleView = titleView
        
    }

    func clickNavigationBarButtonItemAction(_ sender: UIButton) {
        
        if sender == self.navigationItem.leftBarButtonItem?.customView {
            print("leftBarButtonItem")
            
            self.miniPlayerView?.isEnable = true
            
        } else if sender == self.navigationItem.rightBarButtonItem?.customView {
            print("rightBarButtonItem")
            
            self.miniPlayerView?.isEnable = false
        }
    }
}
