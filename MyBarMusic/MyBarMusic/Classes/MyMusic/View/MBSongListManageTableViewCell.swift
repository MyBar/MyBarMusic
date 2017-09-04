//
//  MBSongListManageTableViewCell.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/9/3.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBSongListManageTableViewCell: UITableViewCell {

    @IBOutlet weak var selfBuildSongListButton: UIButton!
    @IBOutlet weak var selfBuildSongListNumLabel: UILabel!
    @IBOutlet weak var collectionSongListButton: UIButton!
    @IBOutlet weak var collectionSongListNumLabel: UILabel!
    @IBOutlet weak var addSongListImageView: UIImageView!
    @IBOutlet weak var manageSongListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapAddSongListImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapAddSongListImageViewAction(_:)))
        self.addSongListImageView.addGestureRecognizer(tapAddSongListImageViewGestureRecognizer)
        
        
        let tapManageSongListImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapManageSongListImageViewAction(_:)))
        self.manageSongListImageView.addGestureRecognizer(tapManageSongListImageViewGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickSongListButtonAction(_ sender: UIButton) {
        if sender == self.selfBuildSongListButton {
            self.selfBuildSongListButton.setTitleColor(UIColor.darkText, for: UIControlState.normal)
            self.collectionSongListButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            
            self.addSongListImageView.isHidden = false
            
        } else if sender == self.collectionSongListButton {
            self.selfBuildSongListButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            self.collectionSongListButton.setTitleColor(UIColor.darkText, for: UIControlState.normal)
            
            self.addSongListImageView.isHidden = true
        }
        
    }
    
    func tapAddSongListImageViewAction(_ gesture: UITapGestureRecognizer) {
        print("tapAddSongListImageViewAction")
    }
    
    func tapManageSongListImageViewAction(_ gesture: UITapGestureRecognizer) {
        print("tapManageSongListImageViewAction")
    }
    
    
}
