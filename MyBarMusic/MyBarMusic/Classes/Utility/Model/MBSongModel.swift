//
//  MBSongModel.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/15.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import HandyJSON

struct MBBitRate: HandyJSON {
    var file_bitrate: Float?
    var free: Float?
    var file_link: String?
    var file_extension: String?
    var original: Float?
    var file_size: Float?
    var file_duration: Float?
    var show_link: String?
    var song_file_id: String?
    var replay_gain: String?
}

///
/// 描述：歌曲模型
///
struct MBSongModel: HandyJSON {
    
    var error_code: String?
    var bitrate: MBBitRate?
    var songinfo: MBSongInfoModel?
    
}
