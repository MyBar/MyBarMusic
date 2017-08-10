//
//  AppDelegate.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var playerManager = MBPlayerManager.shared

    class var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //初始化窗口
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let bundleVersionKey = "CFBundleVersion"
        let currentVersion = Bundle.main.infoDictionary?[bundleVersionKey] as? String
        let lastVersion = UserDefaults.standard.value(forKeyPath: bundleVersionKey) as? String
        
        if currentVersion == lastVersion && lastVersion != nil {
            let navVC = UINavigationController(rootViewController: MBMainViewController())
            let settingVC = MBSettingViewController()
            SlideMenuOptions.hideStatusBar = false
            SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width * 0.8
            let slideMenuController = MBSlideMenuController(mainViewController: navVC, leftMenuViewController: settingVC)
            
            self.window?.rootViewController = slideMenuController
        } else {
            self.window?.rootViewController = MBNewFeatureViewController()
            
            UserDefaults.standard.setValue(currentVersion, forKeyPath: bundleVersionKey)
            UserDefaults.standard.synchronize()
        }
        
        self.window?.makeKeyAndVisible()
        
        //监听网络变化
        MBNetworkReachabilityStatusListener.shared.startNetworkReachabilityStatusListening()
        
        //设置全局控制器状态栏样式
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

