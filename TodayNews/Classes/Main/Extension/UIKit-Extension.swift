//
//  UIKit-Extension.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

protocol NibLoadable {}
extension NibLoadable{
    static func loadViewFromNib() -> Self{
        
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self

    }
}
extension UIBezierPath{
    convenience init(point:CGPoint,radius:CGFloat) {
        self.init(arcCenter: point, radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
    }
}
extension UIButton{
    ///设置图片和文字对其，左右方向
    convenience init(frame:CGRect,imageName:String,text:String) {
        self.init(frame: frame)
        //设置图片和文本对齐
        //设置文本水平居左显示
        self.contentHorizontalAlignment = .left
        self.titleLabel?.textAlignment = .center
        //设置文字距离图片间距为20
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        self.setTitleColor(UIColor.darkGray, for: .normal)
        //设置图片距离左边10
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.setImage(UIImage(named:imageName), for: .normal)
        self.setTitle(text, for: .normal)
    }
    ///上面为图片 下面为文字
    convenience init(frame:CGRect,upImageName:String,downText:String) {
        self.init(frame:frame)
        
        self.setImage(UIImage(named:upImageName), for: .normal)
        self.setTitle(downText, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.contentVerticalAlignment = .top
        self.titleEdgeInsets = UIEdgeInsets(top: 27, left: -20, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.titleLabel?.textAlignment  = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 11)
//        self.backgroundColor = UIColor.red
    }
}

