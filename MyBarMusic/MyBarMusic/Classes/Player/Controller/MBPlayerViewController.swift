//
//  MBPlayerViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/8.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBPlayerViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    
    lazy var playerManager: MBPlayerManager = AppDelegate.delegate.playerManager
    
    lazy var playerControlPadView: MBPlayerControlPadView! = MBPlayerControlPadView.playerControlPadView
    
    lazy var playerAlbumCoverView: MBPlayerAlbumCoverView! = MBPlayerAlbumCoverView.playerAlbumCoverView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBlurEffectForBackgroudImage(imageNamed: "player_albumblur_default")
        
        self.setupNavigation()
        
        self.setupScrollView()

        self.setupPlayerControlPadView()
        
        //监听状态变化
        NotificationCenter.default.addObserver(self, selector: #selector(self.observePlayerManagerStatus(_:)), name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("playerManagerStatus"), object: nil)
    }
    
    deinit {
        print("===============MBPlayerViewController deinit===================")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("playerManagerStatus"), object: nil)
        
        self.playerAlbumCoverView.RemoveAnimation()
    }

    func setupBlurEffectForBackgroudImage(imageNamed: String) {
        let imageView = UIImageView(image: UIImage(named: imageNamed))
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        effectView.frame = self.view.bounds
        self.view.addSubview(effectView)
        
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let color = UIColor.white
        let dict=[NSForegroundColorAttributeName: color]
        self.navigationController?.navigationBar.titleTextAttributes = dict;
        self.navigationItem.title = "QQ音乐，听我想听的歌"
        
        let leftBarButton = UIButton(type: UIButtonType.custom)
        leftBarButton.setBackgroundImage(UIImage(named: "player_btn_close_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        leftBarButton.setBackgroundImage(UIImage(named: "player_btn_close_highlight")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        leftBarButton.frame.size = leftBarButton.currentBackgroundImage!.size
        leftBarButton.addTarget(self, action: #selector(MBPlayerViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.setBackgroundImage(UIImage(named: "player_btn_more_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        rightBarButton.setBackgroundImage(UIImage(named: "player_btn_more_highlight")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.highlighted)
        rightBarButton.frame.size = rightBarButton.currentBackgroundImage!.size
        rightBarButton.addTarget(self, action: #selector(MBPlayerViewController.clickNavigationBarButtonItemAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setupScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navigationBarAndStatusBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        
        var frame = self.view.bounds
        frame.origin.y = navigationBarAndStatusBarHeight
        frame.size.height = frame.size.height - navigationBarAndStatusBarHeight - self.playerControlPadView!.frame.height
        
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView!.bounces = false
        self.scrollView!.isPagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView?.backgroundColor = UIColor.clear
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
                self.playerAlbumCoverView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
                
                self.playerAlbumCoverView.setupAlbumCoverView()
                
                self.scrollView?.addSubview(self.playerAlbumCoverView)
                
            case 2:
                let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
                imageView.image = UIImage(named: "Welcome_3.0_\(index + 1)")
                
                self.scrollView?.addSubview(imageView)
                
            default:
                print("No this Page of Index: \(index)")
                
            }
        }
        
        self.scrollView!.contentOffset.x = self.scrollView!.frame.width
        
        self.view.addSubview(self.scrollView!)
        
    }
    
    func setupPlayerControlPadView() {
        
        self.playerControlPadView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.playerControlPadView!)
        
    }
    
    func observePlayerManagerStatus(_ notification: Notification) {
        switch self.playerManager.playerManagerStatus {
        case .playing:
            print("MBPlayerViewController.playerManager.playerManagerStatus = playing")
            if self.playerAlbumCoverView.isAddAnimation == false {
                self.playerAlbumCoverView.initAnimationWithSpeed(0.1)
            }
            self.playerAlbumCoverView.startAnimation()
            
        case .paused:
            print("MBPlayerViewController.playerManager.playerManagerStatus = paused")
            self.playerAlbumCoverView.pauseAnimation()
            
        case .stopped:
            print("MBPlayerViewController.playerManager.playerManagerStatus = stopped")
            if self.playerAlbumCoverView.isAddAnimation {
                self.playerAlbumCoverView.RemoveAnimation()
            }
            
        case .loadSongModel:
            print("MBPlayerViewController.playerManager.playerManagerStatus = loadSongModel")
            
        case .unknown:
            print("MBPlayerViewController.playerManager.playerManagerStatus = unknown")
            
        case .readyToPlay:
            print("MBPlayerViewController.playerManager.playerManagerStatus = readyToPlay")
            if self.playerAlbumCoverView.isAddAnimation {
                self.playerAlbumCoverView.RemoveAnimation()
            } else {
                self.playerAlbumCoverView.initAnimationWithSpeed(0.1)
            }
            
        case .failed:
            print("MBPlayerViewController.playerManager.playerManagerStatus = failed")
            
        case .none:
            print("MBPlayerViewController.playerManager.playerManagerStatus = none")
        }
    }
    
    func clickNavigationBarButtonItemAction(_ sender: UIButton) {
        
        if sender == self.navigationItem.leftBarButtonItem?.customView {
            print("leftBarButtonItem")
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        } else if sender == self.navigationItem.rightBarButtonItem?.customView {
            print("rightBarButtonItem")
        }
    }
    
    /** UIScrollViewDelegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        
        self.playerControlPadView?.updatePageControlCurrentPage(currentPage)
    }
}
