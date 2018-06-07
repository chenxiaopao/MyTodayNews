//
//  String-Extension.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
extension String{
    //根据字符串计算宽度
    func calculateWidthWithString(font:UIFont)->CGFloat{
        let size = CGSize(width: CGFloat(MAXFLOAT), height: 0)
        return (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:font], context: nil).width
    }
    //根据字符串计算高度
    func calculateHeightWithString(fontSize:UIFont,width:CGFloat)->CGFloat{
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        return (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : fontSize], context: nil).height
    }
}
extension TimeInterval{
    func convertString()->String{
//        把秒数转化为具体的日期
        let date = Date(timeIntervalSince1970: self)
        //获取当前日历
        let calender = Calendar.current
//        获取两个日期的间隔时间
        let comp = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date, to: Date())
        let formatter = DateFormatter()
        guard date.isThisYear()else{
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: date)
        }
//        是否是前天
        if date.isBeforeYesterday(){
            formatter.dateFormat = "前天 HH:mm"
            return formatter.string(from: date)
        }else if calender.isDateInYesterday(date){
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: date)
        }else  if calender.isDateInToday(date){
            if comp.hour! >= 1{
                return String(format: "%d小时前", comp.hour!)
            }else if comp.minute!>=1{
                return String(format: "%d分钟前", comp.minute!)
            }else {
                return "刚刚"
            }
        }else{
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: date)
        }
    }
}
extension Date{
    
//    是否是前天
    func isBeforeYesterday()->Bool{
        let calender = Calendar.current
        let comp = calender.dateComponents([.year,.month,.day], from: self, to: Date())
        return comp.year==0&&comp.month==0&&comp.day == 2
    }
//    是否是今年
    func isThisYear()->Bool{
//        获取当前日历
        let calender = Calendar.current
//        获取日期的年份
        let yearComp = calender.component(.year, from: self)
//        获取当前时间的年份
        let nowYearComp = calender.component(.year, from: Date())
        return yearComp == nowYearComp
    }
}
extension Int{
//    转换评论数
    func convertString() -> String {
        guard self >= 10000 else {
            return String(self)
        }
        return String(format: "%.1f万", Float(self) / 10000.0)
    }
//    转换视频时间
    func convertVideoDuration()->String{
        if self == 0{
            return "00:00"
        }else{
            let hour = self/3600
            let minutes = (self/60)%60
            let seconds = self%60
            if hour > 0{
                return String(format: "%02d:%02d", hour,minutes)
            }else{
                return String(format: "%02d:%02d", minutes,seconds)
            }
        }
    }
}
