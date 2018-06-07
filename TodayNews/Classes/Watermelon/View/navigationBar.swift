//
//  navigationBar.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/24.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
class navigationBar:UIView,NibLoadable{
    var loginSelector:(()->())?
    var releaseSelector:(()->())?
    //iOS11之前默认不开启自动布局，iOS11之后模块打开了，所以原来用frame做的自定义view，需要实现intrinsicContentSize方法。
    @IBOutlet weak var searchBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBtn.layer.masksToBounds = true
        searchBtn.layer.cornerRadius = 10
    }
    override var intrinsicContentSize: CGSize{
        return CGSize(width: kScreenW, height: 44)
    }
    @IBAction func releaseBtnClick(_ sender: UIButton) {
        releaseSelector!()
    }
    @IBAction func loginBtnClick(_ sender: UIButton) {
        loginSelector!()
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
    }
    
}
