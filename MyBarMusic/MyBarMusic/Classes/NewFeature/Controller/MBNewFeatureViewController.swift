//
//  MBNewFeatureViewController.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MBNewFeatureViewController: UIViewController, UIScrollViewDelegate {
    
    let MBNewFeatureImageCount = 5
    
    var scrollView: UIScrollView?
    
    var pageControl: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScrollView()
        self.setupPageControl()
    }
    
    func setupScrollView() {
        let scrollView = UIScrollView(frame: self.view.bounds)
        
        for index in 0..<MBNewFeatureImageCount {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            imageView.image = UIImage(named: "Welcome_3.0_\(index + 1)")
            
            scrollView.addSubview(imageView)
            
            if index == MBNewFeatureImageCount - 1 {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MBNewFeatureViewController.tapAction))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
        // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
        scrollView.contentSize = CGSize(width: CGFloat(MBNewFeatureImageCount) * scrollView.frame.size.width, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        self.scrollView = scrollView
        self.view.addSubview(scrollView)
    }
    
    func setupPageControl() {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = MBNewFeatureImageCount
        pageControl.currentPage = 0
        pageControl.center = CGPoint(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.9)
        pageControl.backgroundColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 253.0 / 255.0, green: 98.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
        
        self.pageControl = pageControl
        self.view.addSubview(pageControl)
    }
    
    func tapAction() {
        let navVC = UINavigationController(rootViewController: MBMainViewController())
        let settingVC = MBSettingViewController()
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width * 0.8
        let slideMenuController = MBSlideMenuController(mainViewController: navVC, leftMenuViewController: settingVC)
        
        self.view.window?.rootViewController = slideMenuController
    }
    
    //UIScrollViewDelegate的方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
    }

}
