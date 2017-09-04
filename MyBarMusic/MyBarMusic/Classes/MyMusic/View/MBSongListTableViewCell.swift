//
//  MBSongListTableViewCell.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/9/4.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBSongListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addNewSongListLabel: UILabel!
    @IBOutlet weak var songListContainerView: UIView!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var downloadImageView: UIImageView!
    
    @IBOutlet weak var songListNameLabel: UILabel!
    
    @IBOutlet weak var songNumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
