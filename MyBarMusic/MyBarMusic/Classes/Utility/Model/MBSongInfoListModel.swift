//
//  MBSongInfoListModel.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/15.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit
import HandyJSON

///
/// 描述：歌曲信息模型
///
struct MBSongInfoModel: HandyJSON {
    
    var artist_id: String?
    var all_artist_ting_uid: String?
    var all_artist_id: String?
    var album_no: String?
    var area: String?
    var hot: String?
    var file_duration: String?
    var del_status: String?
    var resource_type: String?
    var copy_type: String?
    var relate_status: String?
    var all_rate: String?
    var has_mv_mobile: String?
    var toneid: String?
    var song_id: String?
    var ting_uid: String?
    var album_id: String?
    var is_first_publish: String?
    var havehigh: String?
    var charge: String?
    var has_mv: String?
    var learn: String?
    var piao_id: String?
    var listen_total: String?
    var language: String?
    var publishtime: String?
    var pic_big: String?
    var pic_small: String?
    var country: String?
    var lrclink: String?
    var title: String?
    var author: String?
    var album_title: String?
    var versions: String?
    var song_source: String?
    var resource_type_ext: String?
    var korean_bb_song: String?
    var is_new: String?
    var rank_change: String?
    var rank: String?
    var style: String?
    var biaoshi: String?
    var info: String?
    var has_filmtv: String?
    var mv_provider: String?
    var artist_name: String?
    var pic_radio: String?
    var play_type: String?
    var pic_premium: String?
    var pic_huge: String?
    var si_presale_flag: String?
    var distribution: String?
    var si_proxycompany: String?
    var special_type: String?
    var collect_num: String?
    var share_num: String?
    var comment_num: String?
}

///
/// 描述：Billboard信息模型
///
struct MBBillboardInfoModel: HandyJSON {
    var billboard_type: String?
    var billboard_no: String?
    var update_date: String?
    var billboard_songnum: String?
    var havemore: Float?
    var name: String?
    var comment: String?
    var pic_s192: String?
    var pic_s640: String?
    var pic_s444: String?
    var pic_s260: String?
    var pic_s210: String?
    var web_url: String?
}

///
/// 描述：歌曲信息列表模型
///

struct MBSongInfoListModel: HandyJSON {
    
    var error_code: String?
    
    var song_list: [MBSongInfoModel]?
    
    var billboard: MBBillboardInfoModel?
}
