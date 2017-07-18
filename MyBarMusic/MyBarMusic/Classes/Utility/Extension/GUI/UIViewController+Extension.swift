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
        
        self.view.addSubview(miniPlayerView)
        
        return miniPlayerView
    }
    
}
