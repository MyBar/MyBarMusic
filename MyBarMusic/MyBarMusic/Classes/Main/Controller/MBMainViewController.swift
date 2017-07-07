//
//  MBMainViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMainViewController: UIViewController, UIScrollViewDelegate {
    
    var miniPlayerView: MBMiniPlayerView?
    
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        self.setupNavigation()
        
        self.setupScrollView()
        
        self.setupMiniPlayerView()
        
        print(self.view.bounds)
    }
    
    func setupScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
    
        var frame = self.view.bounds
        frame.origin.y = 0//self.navigationController!.navigationBar.frame.maxY
        frame.size.height = frame.size.height - self.navigationController!.navigationBar.frame.maxY - MBMiniPlayerView.shared.frame.height
        
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView!.bounces = false
        self.scrollView!.isPagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.delegate = self
        
        let width = self.scrollView!.frame.width
        let height = self.scrollView!.frame.height
        
        self.scrollView?.contentSize = CGSize(width: 3 * width, height: 0)
        
        for index in 0..<3 {
            
            switch index {
                case 0:
                    let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
                    imageView.image = UIImage(named: "Welcome_3.0_\(index + 1)")
                        
                    self.scrollView?.addSubview(imageView)
                
                case 1:
                    let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
                    imageView.image = UIImage(named: "Welcome_3.0_\(index + 1)")
                    
                    self.scrollView?.addSubview(imageView)
                
                case 2:
                    let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
                    imageView.image = UIImage(named: "Welcome_3.0_\(index + 1)")
                
                    self.scrollView?.addSubview(imageView)
                
                default:
                    print("No this Page of Index: \(index)")
                
            }
        }
        
        self.view.addSubview(self.scrollView!)
    
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
        
        titleView.updateLabelTextColor(titleView.myMusicLabel)
        
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
    
    /** UIScrollViewDelegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)

        let titleView = self.navigationItem.titleView as! MBNavigationItemTitleView
        
        switch currentPage {
            case 0:
                titleView.updateLabelTextColor(titleView.myMusicLabel)
            
            case 1:
                titleView.updateLabelTextColor(titleView.channelLabel)
            
            case 2:
                titleView.updateLabelTextColor(titleView.discoverLabel)
            
            default:
                print("No this Page of Index: \(currentPage)")
            
        }
        
    }

}
