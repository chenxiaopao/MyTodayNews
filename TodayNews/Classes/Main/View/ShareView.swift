    //
//  ShareView.swift
//  ShareView
//
//  Created by 陈思斌 on 2018/5/1.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
protocol shareViewDelegate:class {
    //根据Button的tag属性来区分按钮，默认第一个tag为0
    func shareViewFirst(_ firstScrollViewButton:UIButton)
    //根据Button的tag属性来区分按钮，默认第一个tag为0
    func shareViewSecond(_ secondScrollViewButton:UIButton)
}
class ShareView: UIView {
    weak var delegate:shareViewDelegate?
    private var btnW:CGFloat = 0
    private var btnH:CGFloat = 0
    private let kMarginW : CGFloat = 10
    private var bgViewH:CGFloat = 0
    private let cancelViewH:CGFloat = 40
    private var scrollViewH:CGFloat = 0
    private var bgView:UIView!
    private var firstLineDic:[String:String]!
    private var secondLineDic:[String:String]!
    var btn : UIButton!
    var firstScrollView : UIScrollView!
    var secondScrollView:UIScrollView!
    //用字典来获取图片跟文字[iamgeName:titleName]
    init(firstLineDic:Dictionary<String,String>,secondLineDic:Dictionary<String,String>) {
        super.init(frame:UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.frame = UIScreen.main.bounds
        self.firstLineDic = firstLineDic
        self.secondLineDic = secondLineDic
        scrollViewH = (kScreenH-40)/3/2
        self.btnH = scrollViewH - 20
        self.btnW = btnH - 30
        bgViewH = (kScreenH-40)/3+40
        //初始化时隐藏ShareView
        self.isHidden = true
        //添加点击手势
        addTapGesture()
        //添加背景View
        addBgView()
        addScrollView()

    }
    
    private func addScrollView(){
        //添加第一个scrollView
        firstScrollView = UIScrollView(frame: CGRect(x: kMarginW, y: bgViewH, width: kScreenW-kMarginW*2, height: scrollViewH))
                firstScrollView.alwaysBounceHorizontal = true
        firstScrollView.contentSize = CGSize(width: CGFloat(firstLineDic.count)*(btnW+kMarginW), height: scrollViewH)

        bgView.addSubview(firstScrollView)
        var index:CGFloat = 0
        for (imageName,titleName) in firstLineDic{
            btn = customButton(frame: CGRect(x:0,y:0,width:btnW,height:btnH), originX: kMarginW + index * (btnW+kMarginW), imageName: imageName,titleName:titleName)
            btn.addTarget(self, action: #selector(firstScrollViewclick(sender:)), for: .touchUpInside)
            btn.tag = Int(index)
            firstScrollView.addSubview(btn)
            index+=1
        }
        //添加中间横线
        let bottomLineView = UIView(frame: CGRect(x: 0, y:scrollViewH-1, width: kScreenW, height: 1))
        bottomLineView.backgroundColor =  UIColor.white.withAlphaComponent(0.3)
        bgView.addSubview(bottomLineView)
        
        //添加第二个scrollView
        secondScrollView = UIScrollView(frame: CGRect(x: kMarginW, y: bgViewH, width: kScreenW-kMarginW*2, height: scrollViewH))
        secondScrollView.alwaysBounceHorizontal = true
        secondScrollView.contentSize = CGSize(width: CGFloat(secondLineDic.count)*(btnW+kMarginW), height: scrollViewH)
        bgView.addSubview(secondScrollView)
        index = 0
        for (imageName,titleName) in secondLineDic{
            btn = customButton(frame: CGRect(x:0,y:0,width:btnW,height:btnH), originX: kMarginW + index * (btnW+kMarginW), imageName: imageName,titleName:titleName)
            btn.addTarget(self, action: #selector(secondScrollViewclick(sender:)), for: .touchUpInside)
            btn.tag = Int(index)
            secondScrollView.addSubview(btn)
            index+=1
        }
        
        //添加取消按钮
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: bgViewH-40, width: kScreenW, height: 40))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(hideShareView), for: .touchUpInside)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.backgroundColor = UIColor.white
        bgView.addSubview(cancelBtn)
        
    }
    //第一个scrollView按钮的点击事件
    @objc func firstScrollViewclick(sender:UIButton){
        delegate?.shareViewFirst(sender)
//        print("yi\(sender.tag)")
    }
    //第二个scrollView按钮的点击事件
    @objc func secondScrollViewclick(sender:UIButton){
        delegate?.shareViewSecond(sender)
//        print("er\(sender.tag)")
    }

    
    //shareView添加手势
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideShareView))
        self.addGestureRecognizer(tap)
    }
    //MARK:- 添加背景View
    private func addBgView(){
        bgView = UIView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: bgViewH))
        bgView.backgroundColor = UIColor.lightGray
        self.addSubview(bgView)
    }
    //MARK: - 隐藏ShareView
    @objc func hideShareView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            self.bgView.frame.origin.y += self.bgViewH
            self.firstScrollView.frame.origin.y += (self.bgViewH-10)
            self.secondScrollView.frame.origin.y += (self.bgViewH-10-self.scrollViewH)
        }) { (true) in
            self.isHidden = true
        }
        
    }
    //MARK: - 显示shareView
    func showShareView(){
        UIView.animate(withDuration: 0.2) {
            self.bgView.frame.origin.y -= self.bgViewH
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            self.firstScrollView.frame.origin.y -= (self.bgViewH-10)
            self.secondScrollView.frame.origin.y -= (self.bgViewH-10-self.scrollViewH)
        }) { (true) in}
        self.isHidden = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
class customButton:UIButton{
    init(frame: CGRect,originX:CGFloat,imageName:String,titleName:String) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitle(titleName, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.backgroundColor = UIColor.clear
        self.frame.origin.x = originX
//        self.contentHorizontalAlignment = .center
//        addSubButton(imageName)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height-frame.width, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: frame.width, left: -frame.width, bottom: 0, right: 0)
        
        self.setImage(UIImage(named:imageName), for: .normal)
    }
    private func addSubButton(_ imageName:String){
        let innerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        innerBtn.setImage(UIImage(named:imageName), for: .normal)
        innerBtn.layer.cornerRadius = frame.width/2
        innerBtn.layer.masksToBounds = true
        innerBtn.layer.backgroundColor = UIColor.white.cgColor
        innerBtn.isEnabled = false
        self.addSubview(innerBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    
    
