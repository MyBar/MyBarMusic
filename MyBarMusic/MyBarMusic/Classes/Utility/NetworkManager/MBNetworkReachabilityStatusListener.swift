//
//  MBNetworkReachabilityStatusListener.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/6.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import Foundation
import Alamofire

class MBNetworkReachabilityStatusListener {
    
    static let shared = MBNetworkReachabilityStatusListener()
    
    let networkReachabilityManager = NetworkReachabilityManager()
    
    /**
     *  开启网络状态的监听
     */
    func startNetworkReachabilityStatusListening() {
        networkReachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
            }
        }
        networkReachabilityManager?.startListening()
    }
}
