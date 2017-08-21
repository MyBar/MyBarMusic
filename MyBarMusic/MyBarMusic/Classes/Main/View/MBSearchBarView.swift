//
//  MBSearchBarView.swift
//  MyBarMusic
//
//  Created by lijingui2010 on 2017/8/21.
//  Copyright © 2017年 MyBar. All rights reserved.
//

import UIKit

var searchBarViewHeight: CGFloat = 32

class MBSearchBarView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    class var searchBarView: MBSearchBarView {
        
        let searchBarView = Bundle.main.loadNibNamed("MBSearchBarView", owner: nil, options: nil)?.last as! MBSearchBarView
        
        searchBarView.backgroundImageView.image = UIImage(named: "vc_head_bg")
        
        searchBarView.searchBar.setImage(UIImage(named: "mymusic_search_icon"), for: .search, state: .normal)
        searchBarView.searchBar.backgroundColor = UIColor.clear
        searchBarView.searchBar.tintColor = UIColor.clear
        searchBarView.searchBar.placeholder = "搜索"
        
        for subview in searchBarView.searchBar.subviews {
            if subview.isKind(of: UIView.self) && subview.subviews.count > 0 {
                subview.backgroundColor = UIColor.clear
                subview.subviews[0].removeFromSuperview()
                
                if subview.subviews[0].isKind(of: UITextField.self) {
                    
                    let textField = subview.subviews[0] as! UITextField
                    
                    textField.backgroundColor = UIColor(patternImage: UIImage(named: "mymusic_search_input")!)
                    
                    //设置默认文字颜色
                    let color = UIColor.lightText
                    textField.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSForegroundColorAttributeName : color])
                    
                    
                    
                }
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: searchBarView, action: #selector(MBSearchBarView.tapAlbumCoverViewGestureRecognizer(_:)))
        
        searchBarView.addGestureRecognizer(tapGestureRecognizer)
        
        return searchBarView
    }
    
    func tapAlbumCoverViewGestureRecognizer(_ sender: UITapGestureRecognizer) {
        print("========Tap MBSearchBarView======")
    }
    
}
