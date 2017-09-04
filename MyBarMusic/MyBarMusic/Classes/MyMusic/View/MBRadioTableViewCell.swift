//
//  MBRadioTableViewCell.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/31.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

class MBRadioTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    @IBOutlet weak var radioLabel: UILabel!
    
    @IBOutlet weak var radioDescribeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
