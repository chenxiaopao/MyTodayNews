//
//  NetWorkTool.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/19.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol NetWorkToolProtocol{
  
}

struct NetWorkTool:NetWorkToolProtocol {}

extension NetWorkToolProtocol{
    //MARK: - 首页-------------------------------------------
    //MARK:  首页新闻标题数据
    static  func loadHomeNewTitleData(completeHandler:@escaping (_ newTitles:[HomeNewsTitle])->()){
        let url:String = BASE_URL + "/article/category/get_subscribed/v2/?"
        let param = ["device_id":device_id,
                     "aid":aid]
        Alamofire.request(url, parameters: param).responseJSON { (response) in
            guard response.result.isSuccess else {return}
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {return }
                if let dataDict = json["data"].dictionary{
                    if let datas = dataDict["data"]?.arrayObject{
                        var titles = [HomeNewsTitle]()
                        titles.append(HomeNewsTitle.deserialize(from: "{\"category\":\"\",\"name\":\"推荐\"}")!)
                        titles += datas.flatMap({ HomeNewsTitle.deserialize(from: $0 as? Dictionary)})
                        completeHandler(titles)
                    }
                }
            }
        }
    }
    
    /// 首页顶部导航栏搜索推荐标题内容
  
    static func loadHomeSearchSuggestInfo(_ completionHandler: @escaping (_ searchSuggest: String,_ searchArr:[SuggestModel]) -> ()) {
        let url = BASE_URL + "/search/suggest/homepage_suggest/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].dictionary {
                     var arr = [SuggestModel]()
                     let str = data["homepage_search_suggest"]?.string
                     if let suggestArr = data["suggest_words"]?.arrayObject{
                        arr+=suggestArr.flatMap({
                           SuggestModel.deserialize(from: $0 as? Dictionary)
                        })
                     }
                     completionHandler(str!,arr)
                }
            }
        }
    }
    
    //MARK:  获取频道推荐标题
    static func loadHomeRecommendCategory(completionHandler:@escaping(_ titles:[HomeNewsTitle])->()){
        let url = BASE_URL + "/article/category/get_extra/v1/?"
        let param = ["device_id":device_id,
                      "aid":aid]
        Alamofire.request(url, parameters: param).responseJSON { (response) in
            guard response.result.isSuccess else {return}
            if let value = response.result.value {
                let json = JSON(value)
                let dataDict = json["data"].dictionary
                if let datas = dataDict!["data"]?.arrayObject{
                    completionHandler(datas.flatMap({
                        HomeNewsTitle.deserialize(from: $0 as? [String : Any])
                    }))
                }
            }
        }
    }
   
    //MARK:   下啦刷新数据
    static func loadApiNewsFeeds(category:NewsTitleCategory,ttFrom:TTFrom,_ completionHandler: @escaping ( _ maxBehotTime:TimeInterval,_ news:[NewsModel])->()){
        //下啦刷新时间
        let pullTime = Date().timeIntervalSince1970
        let url = BASE_URL + "/api/news/feed/v78/?"
//      https://is.snssdk.com/api/news/feed/v78/?device_id=49202147072$count=20$category=weitoutiao&refresh_reason=1&strict=0&detail=1&iid=28138826471
        let params = ["device_id":device_id,
                      "count":20,
                      "list_count":15,
                      "category":category.rawValue,
                      "min_behot_time":pullTime,
                      "strict":0,
                      "detail":1,
                      "refresh_reason":1,
                      "tt_from":ttFrom,
                      "iid":iid] as [String:Any]
        Alamofire.request(url,parameters:params).responseJSON{(response) in
            guard response.result.isSuccess else{return}
            if let value = response.result.value{
                let json = JSON(value)
                guard json["message"] == "success" else{return }
                guard let datas = json["data"].array else{return }
               
                completionHandler(pullTime,datas.flatMap({
                    NewsModel.deserialize(from: $0["content"].string)
                }))
            }
        }
    }

    //MARK:  上啦加载更多
    static func loadMoreApiNewsFeeds(category:NewsTitleCategory,ttFrom:TTFrom,maxBehotTime:TimeInterval,listCount:Int,_ completionHandler: @escaping (_ news : [NewsModel])->()){
        let url = BASE_URL + "/api/news/feed/v78/?"
        let params = ["device_id":device_id,
                      "count":20,
                      "list_count":listCount,
                      "category":category.rawValue,
                      "max_behot_time":maxBehotTime,
                      "strict":0,
                      "detail":1,
                      "refresh_reason":1,
                      "tt_from":ttFrom,
                      "iid":iid] as [String:Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else{return}
            if let value = response.result.value{
                let json = JSON(value)
                guard json["message"] == "success" else{return}
                guard let datas = json["data"].array else{return}
                
                completionHandler(datas.flatMap({
                    NewsModel.deserialize(from: $0["content"].string)
                }))
            }
        }
    }


    //MARK: - 火山小视频----------------------------
    //MARK: - 获取小视频标题数组
    static func loadSmallVideoCategories(completionHandler: @escaping (_ newsTitles: [HomeNewsTitle]) -> ()) {
        let url = BASE_URL + "/category/get_ugc_video/1/?"
        let params = ["devide_id":device_id,
                      "iid":iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {return}
            if let value = response.result.value{
                let json = JSON(value)
                guard json["message"] == "success" else{return}
                if let dataDict = json["data"].dictionary{
                    if let datas = dataDict["data"]?.arrayObject{
                        var titles = [HomeNewsTitle]()
                        titles.append(HomeNewsTitle.deserialize(from: "{\"category\":\"hotsoon_video\",\"name\":\"推荐\"}")!)
                        titles += datas.flatMap({
                            HomeNewsTitle.deserialize(from: $0 as? Dictionary)
                        })
                        completionHandler(titles)
                    }
                }
            }
        }
        
    }

    
    //MARK: - 我的界面数据
    static func loadMyCellData(completionHandler:@escaping (_ sections :[[MyCellModel]])->()){
        let url = BASE_URL + "/user/tab/tabs/?"
        let params = ["device_id": device_id]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {return}
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else{return}
                var mySections = [[MyCellModel]]()
                mySections.append([MyCellModel.deserialize(from: "{\"text\":\"我的关注\",\"grey_text\":\"\"}")!])
                if let data = json["data"]["sections"].arrayObject{
                   
                    mySections += data.flatMap({ item in
                        (item as! [Any]).flatMap({
                            MyCellModel.deserialize(from: $0 as? Dictionary)
                        })
                        
                    })
                    completionHandler(mySections)
                }
                
            }
        }
    }
    
    
    //MARK: - 西瓜视频数据----==========================
    static func loadVideoApiCategories(completeHandler:@escaping (_ newsTitle:[HomeNewsTitle])->()){
        //http://is.snssdk.com/video_api/get_category/v1/?device_id=49202147072&aid=13
        let url  = BASE_URL + "/video_api/get_category/v1/?"
        let params = ["device_id":device_id,"aid":13]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else{return }
            if let value = response.result.value{
                let json = JSON(value)
                guard json["message"]=="success" else{return }
                if let datas = json["data"].arrayObject{
                    var titles = [HomeNewsTitle]()
                    titles.append(HomeNewsTitle.deserialize(from: "{\"category\":\"video\",\"name\":\"推荐\"}")!)
                    titles += datas.flatMap({
                        HomeNewsTitle.deserialize(from: $0 as? Dictionary)
                    })
                    completeHandler(titles)
                }
            }
        }
    }
   static func getCaptcha(phoneNumber:String,captcha:String,compleHander:@escaping (_ phoneNumber:String)->()){
      let url = CAPTCHA_URL
      let param = ["app":"sms.send",
                   "tempid":"51429",
                   "param":captcha,
                   "phone":phoneNumber,
                   "appkey":"26850",
                   "sign":"2281a1ec27a9effa55d9dc4151fe22de",
                   "format":"json"]
      Alamofire.request(url, parameters: param).responseJSON{ (response) in
            guard response.result.isSuccess else {return}
         if let value = response.result.value{
            let json = JSON(value)
            guard json["success"] == "1" else {return}
            let phone = json["result"]["phone"].string
            compleHander(phone!)
         }
      }
   }

   
   
    
    /// 解析头条的视频真实播放地址
    static func parseVideoRealURL(video_id:String,completionHandler:@escaping (_ realVideo:RealVideo)->()) {
         let r = arc4random() // 随机数
      
         let url: NSString = "/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)" as NSString
         let data: NSData = url.data(using: String.Encoding.utf8.rawValue)! as NSData
         // 使用 crc32 校验
         var crc32: UInt64 = UInt64(data.getCRC32())
         // crc32 可能为负数，要保证其为正数
         if crc32 < 0 { crc32 += 0x100000000 }
         // 拼接 url
         let realURL = "http://i.snssdk.com/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)&s=\(crc32)"
      
         Alamofire.request(realURL).responseJSON { (response) in
            // 网络错误的提示信息
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
               completionHandler(RealVideo.deserialize(from: JSON(value)["data"].dictionaryObject)!)
            }
         }
   }
   
}


