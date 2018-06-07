//
//  SearchBar.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class SearchBar: UIView ,NibLoadable{
    @IBOutlet weak var searchBar: UISearchBar!
    var cancelSelector:(()->())?
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        cancelSelector!()
    }
    override var intrinsicContentSize: CGSize{
        return CGSize(width: kScreenW, height: 40)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
