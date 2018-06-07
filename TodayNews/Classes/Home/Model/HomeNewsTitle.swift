//
//  HomeNewsTitles.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import Foundation
import HandyJSON

struct HomeNewsTitle:HandyJSON{
    var category:NewsTitleCategory = .recommend
    var web_url:String = ""
    var flags:Int = 0
    var name:String = ""
    var tip_new:Int = 0
    var default_add:Int = 0
    var concern_id:String = ""
    var type:Int = 0
    var icon_url: String = ""
    
    var selected: Bool = true
//    var stick:Int = 0
}
enum NewsTitleCategory:String,HandyJSONEnum{
//    时尚
    case fashion = "news_fashion"
//    历史
    case history = "news_history"
//    育儿
    case baby = "news_baby"
//    搞笑
    case funny = "funny"
//    数码
    case digital = "digital"
//    美食
    case food = "news_food"
//    养生
    case regimen = "news_regimen"
//    电影
    case movie = "movie"
//    手机
    case cellphone = "cellphone"
//    旅游
    case travel = "news_travel"
//    宠物
    case pet = "宠物"
//    情感
    case emotion = "emotion"
//    家居
    case home = "news_home"
//    教育
    case edu = "news_edu"
//    三农
    case agriculture = "news_agriculture"
//    孕产
    case pregnancy = "pregnancy"
//    文化
    case culture = "news_culture"
//    游戏
    case game = "news_game"
//    股票
    case stock = "stock"
//    科学
    case science = "science_all"
//    动漫
    case comic = "news_comic"
//    故事
    case story = "news_story"
//    收藏
    case collect = "news_collect"
//    精选
    case boutique = "boutique"
//    语录
    case essaySaying = "essay_saying"
//    星座
    case astrology = "news_astrology"
//    美图
    case wonderful = "image_wonderful"
//    避谣
    case rumor = "rumor"
//    正能量
    case positive = "positive"
//    中国新唱将
    case 中国新唱将 = "中国新唱将"
//    微头条
    case weitoutiao = "weitoutiao"
//    互联网法院
    case court = "high_court"
//    公益
    case welfare = "public_welfare"
//    中国好表演
    case 中国好表演 = "中国好表演"
//    火山直播
    case 火山直播 = "hotsoon"
//    彩票
    case 彩票 = "彩票"
//    组图
    case 组图 = "组图"
//    直播
    case liveTalk = "live_talk"
//    科技
    case newsTech = "news_tech"
//    问答
    case questionAndAnswer = "question_and_answer"
//    趣图
    case imageFunny = "image_funny"

//    街拍
    case imagePPMM = "image_ppmm"
//    段子
    case essayJoke = "essay_joke"
//    视频
    case video = "video"
//    推荐
    case recommend = "__all__"
//    放心购
    case fangXinGou = "fangxingou"
//    健康
    case health = "news_health"
//    军事
    case newsMilitary = "news_military"
//    新时代
    case nineTeenth = "nineteenth"
//    娱乐
    case newsEntertainment = "news_entertainment"
//    财经
    case newFinance = "news_finance"
//    传媒
    case media = "media"
//    热点
    case hot = "news_hot"
//    懂车帝
    case car = "news_car"
//    体育
    case sports = "news_sports"
//    地区eg.福州
    case local = "news_local"
//    小说
    case novel = "novel_channel"
//    房产
    case house = "news_house"
//    特卖
    case teMai = "jinritemai"
//    国际
    case newsWorld = "news_world"
//    两会
    case 两会 = "两会"
    
    /// 小视频 推荐
    case hotsoonVideo = "hotsoon_video"
    /// 小视频 颜值/美女
    case ugcVideoBeauty = "ugc_video_beauty"
    /// 小视频 随拍
    case ugcVideoCasual = "ugc_video_casual"
    /// 小视频 美食
    case ugcVideoFood = "ugc_video_food"
    /// 小视频 户外
    case ugcVideoLife = "ugc_video_life"
    
    

    
    /// 西瓜视频社会
    case subvSociety="subv_society"
    ///新农村
    case subv_tt_video_agriculture="subv_tt_video_agriculture"
    ///游戏
    case subv_game="subv_game"
    ///美食
    case subv_tt_video_food="subv_tt_video_food"
    ///爱生活
    case subv_life = "subv_life"
    ///体育
    case subv_tt_video_sports="subv_tt_video_sports"
    ///影视
    case subv_movie="subv_movie"
    ///音乐
    case subv_voice="subv_voice"
}


