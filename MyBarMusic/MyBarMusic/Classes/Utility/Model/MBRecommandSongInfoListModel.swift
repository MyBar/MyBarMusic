//
//  MBRecommandSongInfoListModel.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/22.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import Foundation
import HandyJSON

///
/// 描述：歌曲信息列表模型
///

struct MBResult: HandyJSON {
    
    var list: [MBSongInfoModel]?
}

struct MBRecommandSongInfoListModel: HandyJSON {
    
    var error_code: String?
    
    var result: MBResult?
}
