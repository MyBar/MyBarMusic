//
//  MBSongListModel.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/15.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import HandyJSON

///
/// 描述：歌曲列表模型
///

class MBSongListModel: HandyJSON {
    
    required init() {
        
    }
    
    var error_code: String?
    
    var song_list: [MBSongModel]?
}
