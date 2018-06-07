//
//  Commom.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kStatusBarH:CGFloat = 20
let kNavigationBarH:CGFloat = 44
let kSecondLaunchKey : String = "kSecondLaunchKey"
let kMyChannelTitleKey: String = "kMyChannelTitleKey"
let kRecommendChannelTitleKey: String = "kRecommendChannelTitleKey"
let isNight = "isNight"

let image2Width: CGFloat = (kScreenW - 35) * 0.5
//  三张图片大小
let image3Width: CGFloat = (kScreenW - 45) / 3
//服务器地址
let BASE_URL = "https://is.snssdk.com"
let CAPTCHA_URL = "https://sapi.k780.com/?"
let device_id:Int = 49202147072
let aid:Int = 13
let iid:Int = 28138826471
/// 从哪里进入头条
enum TTFrom: String {
    case pull = "pull"
    case loadMore = "load_more"
    case auto = "auto"
    case enterAuto = "enter_auto"
    case preLoadMoreDraw = "pre_load_more_draw"
}
