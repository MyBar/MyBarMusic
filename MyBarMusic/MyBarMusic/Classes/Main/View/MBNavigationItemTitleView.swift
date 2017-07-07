//
//  MBNavigationItemTitleView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/5.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBNavigationItemTitleView: UIView {

    @IBOutlet weak var myMusicLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var discoverLabel: UILabel!
    
    private static var titleView: MBNavigationItemTitleView? = nil
    
    class var shared: MBNavigationItemTitleView {
        
        if self.titleView == nil {
            self.titleView = Bundle.main.loadNibNamed("MBNavigationItemTitleView", owner: nil, options: nil)?.last as? MBNavigationItemTitleView
        }
        
        return self.titleView!
    }
    
    func updateLabelTextColor(_ label: UILabel) {
        if label == self.myMusicLabel {
            self.myMusicLabel.textColor = UIColor.white
            self.channelLabel.textColor = UIColor.lightText
            self.discoverLabel.textColor = UIColor.lightText
        } else if label == self.channelLabel {
            self.myMusicLabel.textColor = UIColor.lightText
            self.channelLabel.textColor = UIColor.white
            self.discoverLabel.textColor = UIColor.lightText
        } else {
            self.myMusicLabel.textColor = UIColor.lightText
            self.channelLabel.textColor = UIColor.lightText
            self.discoverLabel.textColor = UIColor.white
        }
    }
}
