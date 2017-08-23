//
//  MBSearchSongModel.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/22.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import Foundation
import HandyJSON

///
/// 描述：搜索歌曲模型
///
struct MBSearchSongModel: HandyJSON {
    var weight: String?
    var songname: String?
    var songid: String?
    var has_mv: String?
    var yyr_artist: String?
    var resource_type_ext: String?
    var artistname: String?
    var info: String?
    var resource_provider: String?
    var control: String?
    var encrypted_songid: String?
}

struct MBSearchSongListModel: HandyJSON {
    
    var song: [MBSearchSongModel]?
    var error_code: String?
    var order: String?
    
}
