//
//  MBPlayerAlbumCoverView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/11.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBPlayerAlbumCoverView: UIView {

    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var lyricLabel: UILabel!
    @IBOutlet weak var playerEffectView: UIView!
    
    class var playerAlbumCoverView: MBPlayerAlbumCoverView {
        
        let playerAlbumCoverView = Bundle.main.loadNibNamed("MBPlayerAlbumCoverView", owner: nil, options: nil)?.last as? MBPlayerAlbumCoverView
        
        playerAlbumCoverView?.backgroundColor = UIColor.clear
        
        playerAlbumCoverView?.setupAlbumCoverView()
        
        return playerAlbumCoverView!
    }
    
    func setupAlbumCoverView() {
        
        self.albumCoverImageView.image = UIImage(named: "LaunchImage")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let margin: CGFloat = 8.0
        
        let albumMargin: CGFloat = 24.0
        
        
        let width = self.frame.width - 2 * albumMargin
        
        let height = self.frame.height - playerEffectView.frame.maxY - lyricLabel.frame.height - margin - 2 * albumMargin
        
        if width >= height {
            
            self.albumCoverImageView.frame = CGRect(x: albumMargin + (width - height) / 2, y: albumMargin + playerEffectView.frame.maxY, width: height, height: height)
        } else {
            self.albumCoverImageView.frame = CGRect(x: albumMargin, y: albumMargin + playerEffectView.frame.maxY + (height - width) / 2, width: width, height: width)
        }
        
        self.albumCoverImageView.layer.cornerRadius = self.albumCoverImageView.frame.width / 2
        self.albumCoverImageView.layer.masksToBounds = true
    }

}
