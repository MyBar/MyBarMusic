//
//  MBLoginTableViewCell.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/28.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBLoginTableViewCell: UITableViewCell {

    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userCoverImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userLevelImageView: UIImageView!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userInfoView.isHidden = true
        self.userCoverImageView.layer.cornerRadius = self.userCoverImageView.frame.width / 2
        self.userCoverImageView.layer.masksToBounds = true
        
        self.loginButton.setBackgroundImage(UIImage(named: "button_h"), for: UIControlState.highlighted)
        self.loginButton.setTitleColor(UIColor.white, for: UIControlState.highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
