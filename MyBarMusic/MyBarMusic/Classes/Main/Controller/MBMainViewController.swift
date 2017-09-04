//
//  MBMainViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MBMainViewController: UIViewController, UIScrollViewDelegate {
    
    var miniPlayerView: MBMiniPlayerView?
    
    var scrollView: UIScrollView?
    
    var searchBarView: MBSearchBarView?
    
    var mymusicVC: MBMyMusicViewController?
    
    var channelVC: MBChannelViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        self.setupNavigation()
        
        self.setupSearchBarView()
        
        self.setupScrollView()
        
        self.miniPlayerView = self.setupMiniPlayerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //放在这里是因为多个页面要共享同一个miniPlayerView，但是相同的miniPlayerView在同一时间只能加在某一个页面，即在这个页面添加了，那会从另一个页面中会移除
        self.miniPlayerView = self.setupMiniPlayerView()
    }
    
    func setupScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navigationBarAndStatusBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
    
        var frame = self.view.bounds
        frame.origin.y = searchBarViewHeight
        frame.size.height = frame.size.height - MBMiniPlayerView.shared.frame.height - navigationBarAndStatusBarHeight - searchBarViewHeight
        
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
                    self.mymusicVC = MBMyMusicViewController()
                    self.mymusicVC!.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
                    
                    self.scrollView?.addSubview(self.mymusicVC!.view)
                
                case 1:
                    self.channelVC = MBChannelViewController()
                    channelVC!.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
                    
                    self.scrollView?.addSubview(self.channelVC!.view)
                
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

    func setupNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "vc_head_bg"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftBarButton = UIButton(type: UIButtonType.custom)
        leftBarButton.setBackgroundImage(UIImage(named: "top_tab_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        leftBarButton.setBackgroundImage(UIImage(named: "top_tab_more_h")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        leftBarButton.frame.size = leftBarButton.currentBackgroundImage!.size
        leftBarButton.addTarget(self, action: #selector(MBMainViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.setBackgroundImage(UIImage(named: "search_all")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        rightBarButton.setBackgroundImage(UIImage(named: "search_all_h")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        rightBarButton.frame.size = rightBarButton.currentBackgroundImage!.size
        rightBarButton.addTarget(self, action: #selector(MBMainViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        let titleView = MBNavigationItemTitleView.shared
        titleView.backgroundColor = UIColor.clear
        titleView.myMusicLabel.text = "我的"
        titleView.channelLabel.text = "音乐馆"
        titleView.discoverLabel.text = "发现"
        
        titleView.updateLabelTextColor(titleView.myMusicLabel)
        
        let tapMyMusicLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MBMainViewController.tapTitleViewGestureRecognizerAction(_:)))
        let tapChannelLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MBMainViewController.tapTitleViewGestureRecognizerAction(_:)))
        let tapDiscoverLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MBMainViewController.tapTitleViewGestureRecognizerAction(_:)))
        
        titleView.myMusicLabel.isUserInteractionEnabled = true
        titleView.channelLabel.isUserInteractionEnabled = true
        titleView.discoverLabel.isUserInteractionEnabled = true
        
        titleView.myMusicLabel.addGestureRecognizer(tapMyMusicLabelGestureRecognizer)
        titleView.channelLabel.addGestureRecognizer(tapChannelLabelGestureRecognizer)
        titleView.discoverLabel.addGestureRecognizer(tapDiscoverLabelGestureRecognizer)
        
        self.navigationItem.titleView = titleView
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
    }
    
    func setupSearchBarView() {
        
        let searchBarViewSuperView = UIView()
        var frame = self.view.bounds
        frame.origin.y = 0
        frame.size.height = searchBarViewHeight
        searchBarViewSuperView.frame = frame
        searchBarViewSuperView.backgroundColor = UIColor.clear
        
        self.searchBarView = MBSearchBarView.searchBarView
        
        self.searchBarView?.frame = searchBarViewSuperView.frame
        
        searchBarViewSuperView.addSubview(self.searchBarView!)
        
        self.view.addSubview(searchBarViewSuperView)
        
    }
    
    func tapTitleViewGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        let titleView = self.navigationItem.titleView as! MBNavigationItemTitleView
        
        let label = sender.view as! UILabel
        
        let currentPage = Int(self.scrollView!.contentOffset.x / self.scrollView!.frame.width + 0.5)
        
        if label == titleView.myMusicLabel && currentPage != 0 {
            self.scrollView!.contentOffset.x = 0
            titleView.updateLabelTextColor(label)
        } else if label == titleView.channelLabel && currentPage != 1 {
            self.scrollView!.contentOffset.x = self.scrollView!.frame.width
            titleView.updateLabelTextColor(label)
        } else if label == titleView.discoverLabel && currentPage != 2 {
            self.scrollView!.contentOffset.x = self.scrollView!.frame.width * 2
            titleView.updateLabelTextColor(label)
        }
        
    }

    func clickNavigationBarButtonItemAction(_ sender: UIButton) {
        
        if sender == self.navigationItem.leftBarButtonItem?.customView {
            print("leftBarButtonItem")
            
            self.slideMenuController()?.toggleLeft()
            
        } else if sender == self.navigationItem.rightBarButtonItem?.customView {
            print("rightBarButtonItem")
            
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
