//
//  UIViewController+Extension.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/16.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

extension UIViewController {

    func setupMiniPlayerView() -> MBMiniPlayerView {
        let miniPlayerView = MBMiniPlayerView.shared
        
        if self.view.subviews.contains(miniPlayerView) == false {
            self.view.addSubview(miniPlayerView)
        }
        
        miniPlayerView.isEnable = miniPlayerView.playerManager.songInfoList != nil && miniPlayerView.playerManager.songInfoList!.count > 0
        
        return miniPlayerView
    }
}
