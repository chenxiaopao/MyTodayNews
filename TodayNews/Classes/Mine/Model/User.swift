//
//  User.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/20.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import Foundation
import SQLite
struct user {
//    let id = Expression<Int64>("id")
//    let userName = Expression<String>("userName")
//    let password = Expression<String?>("password")
//    let phone = Expression<String?>("phone")
//    let address = Expression<String?>("address")
//    let sex = Expression<String?>("sex")
//    let birthDay = Expression<Date?>("brithDay")
//    let description = Expression<String?>("description")
    var id:Int64 = 0
    var userName:String = ""
    var password:String = ""
    var phone:String = ""
    var avator:Blob!
    var address : String = ""
    var sex:String = ""
    var birthDay:Date = Date()
    var description:String = ""
    init() {}
    init(id:Int64,userName:String,avator:Blob,phone:String){
        self.id = id
        self.userName = userName
        self.avator = avator
        self.phone = phone
    }
}
