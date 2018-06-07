//
//  SearchHistoryReusableView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class SearchHistoryReusableView: UICollectionReusableView {
   
    
    @IBOutlet weak var bottomLineConstrainst: NSLayoutConstraint!
    
    @IBOutlet weak var histroyButton: UIButton!
    
    @IBAction func deleteButtonClick(_ sender: UIButton) {
    }
    @IBAction func historyButtonClick(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineConstrainst.constant = 1
    }
    
}
