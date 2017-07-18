//
//  MBNetworkManager.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/7/18.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

class MBNetworkManager {
    
    class func fetchSongInfoList(channelID: String, offset: Int? = nil, completionHandler: @escaping (_ isSuccess: Bool, _ songInfoListModel: MBSongInfoListModel?) -> Void) {
        
        let urlStr = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=\(channelID)&size=10&offset=\(offset ?? 0)"
        
        self.fetch(urlStr) { (isSuccess, songInfoListModel) in
            completionHandler(isSuccess, songInfoListModel)
        }
    }
    
    class func fetchSong(songID: String, completionHandler: @escaping (_ isSuccess: Bool, _ song: MBSongModel?) -> Void) {
        
        let urlStr = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.playAAC&songid=\(songID)"
        
        self.fetch(urlStr) { (isSuccess, song) in
            completionHandler(isSuccess, song)
        }
    }
    
    private class func fetch<T: HandyJSON>(_ url: URLConvertible, completionHandler: @escaping (_ isSuccess: Bool, _ model: T?) -> Void) {
        
        Alamofire.request(url)
            .responseString { response in
                
                if response.error != nil {
                    
                    print("Response error: \(String(describing: response.error))")
                    
                    completionHandler(false, nil)
                    
                } else {
                    
                    if let resp = response.response {
                        
                        if resp.statusCode == 200 {
                            //JSON解析， 做逻辑
                            if let model = T.deserialize(from: response.result.value) {
                                completionHandler(true, model)
                            }
                        } else {
                            
                            completionHandler(false, nil)
                        }
                        
                    }
                }
        }
    }
    
}
