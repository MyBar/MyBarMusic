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

enum Router: URLRequestConvertible {
    
    case songInfoList(method: String, type: String, size: Int, offset: Int)
    case song(method: String, songid: String)
    case lrc(method: String, songid: String)
    case singer(method: String, tinguid: String)
    case singerSongInfoList(method: String, tinguid: String, limits: Int, offset: Int, useCluster: Int, order: Int)
    case recommandSongInfoList(method: String, songid: String, num: Int)
    case search(method: String, query: String)
    
    static let baseURLString = "http://tingapi.ting.baidu.com/v1/restserver/ting"
    static let perPage = 15
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .songInfoList(method, type, size, offset):
                return ("", ["method": method, "type": type, "size": size, "offset": offset])
                
            case let .song(method, songid):
                return ("", ["method": method, "songid": songid])
                
            case let .lrc(method, songid):
                return ("", ["method": method, "songid": songid])
                
            case let .singer(method, tinguid):
                return ("", ["method": method, "tinguid": tinguid])
                
            case let .singerSongInfoList(method, tinguid, limits, offset, useCluster, order):
                return ("", ["method": method, "tinguid": tinguid, "limits": limits, "offset": offset, "use_cluster": useCluster, "order": order])
                
            case let .recommandSongInfoList(method, songid, num):
                return ("", ["method": method, "songid": songid, "num": num])
                
            case let .search(method, query):
                return ("", ["method": method, "query": query])
                
            }
        }()
        
        let url = try Router.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

class MBNetworkManager {
    
    private static var request: DataRequest?
    
    class func cancelFetchTask() {
        guard request != nil else {
            return
        }
        
        request?.cancel()
        request = nil
    }
    
    class func fetchSongInfoList(channelID: String, offset: Int? = nil, completionHandler: @escaping (_ isSuccess: Bool, _ songInfoListModel: MBSongInfoListModel?) -> Void) {
        
        self.fetch(Router.songInfoList(method: "baidu.ting.billboard.billList", type: channelID, size: Router.perPage, offset: (offset ?? 0))) { (isSuccess, songInfoListModel) in
            completionHandler(isSuccess, songInfoListModel)
        }
    }
    
    class func fetchSong(songID: String, completionHandler: @escaping (_ isSuccess: Bool, _ song: MBSongModel?) -> Void) {
        
        self.fetch(Router.song(method: "baidu.ting.song.playAAC", songid: songID)) { (isSuccess, song) in
            completionHandler(isSuccess, song)
        }
    }
    
    class func fetchLRC(songID: String, completionHandler: @escaping (_ isSuccess: Bool, _ lrc: MBLRCModel?) -> Void) {
        
        self.fetch(Router.song(method: "baidu.ting.song.lry", songid: songID)) { (isSuccess, lrc) in
            completionHandler(isSuccess, lrc)
        }
    }
    
    class func fetchSinger(tinguid: String, completionHandler: @escaping (_ isSuccess: Bool, _ singer: MBSingerModel?) -> Void) {
        
        self.fetch(Router.singer(method: "baidu.ting.artist.getInfo", tinguid: tinguid)) { (isSuccess, singer) in
            completionHandler(isSuccess, singer)
        }
    }
    
    class func fetchSingerSongInfoList(tinguid: String, offset: Int? = nil, completionHandler: @escaping (_ isSuccess: Bool, _ songInfoListModel: MBSongInfoListModel?) -> Void) {
        
        self.fetch(Router.singerSongInfoList(method: "baidu.ting.artist.getSongList", tinguid: tinguid, limits: Router.perPage, offset: (offset ?? 0), useCluster: 1, order: 2)) { (isSuccess, songInfoListModel) in
            completionHandler(isSuccess, songInfoListModel)
        }
    }
    
    class func fetchSearchSongList(query: String, completionHandler: @escaping (_ isSuccess: Bool, _ searchSongListModel: MBSearchSongListModel?) -> Void) {
        
        self.fetch(Router.search(method: "baidu.ting.search.catalogSug", query: query)) { (isSuccess, searchSongListModel) in
            completionHandler(isSuccess, searchSongListModel)
        }
    }
    
    class func fetchRecommandSongInfoList(songID: String, completionHandler: @escaping (_ isSuccess: Bool, _ recommandSongInfoListModel: MBRecommandSongInfoListModel?) -> Void) {
        
        self.fetch(Router.recommandSongInfoList(method: "baidu.ting.song.getRecommandSongList", songid: songID, num: Router.perPage)) { (isSuccess, recommandSongInfoListModel) in
            completionHandler(isSuccess, recommandSongInfoListModel)
        }
    }
    
    private class func fetch<T: HandyJSON>(_ url: URLRequestConvertible, completionHandler: @escaping (_ isSuccess: Bool, _ model: T?) -> Void) {
        
        request = Alamofire.request(url)
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
