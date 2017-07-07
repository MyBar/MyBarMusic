//
//  MBMiniPlayerAlbumCoverView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/6.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBMiniPlayerAlbumCoverView: UIView {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var musicNameLabel: UILabel!

    @IBOutlet weak var lyricLabel: UILabel!
    
    class var miniPlayerAlbumCoverView: MBMiniPlayerAlbumCoverView {
        
        let miniPlayerAlbumCoverView = Bundle.main.loadNibNamed("MBMiniPlayerAlbumCoverView", owner: nil, options: nil)?.last as? MBMiniPlayerAlbumCoverView
        
        miniPlayerAlbumCoverView!.albumImageView.layer.cornerRadius = miniPlayerAlbumCoverView!.albumImageView.frame.width * 0.5;
        miniPlayerAlbumCoverView!.albumImageView.layer.masksToBounds = true
        
        miniPlayerAlbumCoverView?.backgroundColor = UIColor(patternImage: UIImage(named: "vc_bg")!)
        
        return miniPlayerAlbumCoverView!
    }
}
