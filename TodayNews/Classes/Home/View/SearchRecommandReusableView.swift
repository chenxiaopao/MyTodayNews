//
//  SearchRecommandReusableView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class SearchRecommandReusableView: UICollectionReusableView,NibLoadable {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btnShowRecommend: UIButton!
    var closeSelector:((_ sender:UIButton)->())?
    @IBOutlet weak var bottomLineConstraintsHeight: NSLayoutConstraint!
    var showSelector:(()->())?
    
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func ShowRecommendClick(_ sender: UIButton) {
        showSelector!()
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        closeSelector!(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineConstraintsHeight.constant = 1
        btnShowRecommend.isHidden = true
        
    }
    
}
