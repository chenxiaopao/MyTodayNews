//
//  smallVIdeopopView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
protocol smallVIdeoPopViewDelegate:class {
    func popViewDelegate(index:Int)
}
class smallVIdeoPopView: UIView {
    var btnframe:CGRect!
    var collectionView:UICollectionView!
    var index:Int!
    var smallVideos = [NewsModel]()
    var delegate:smallVIdeoPopViewDelegate?
    init(frame: CGRect,btnframe:CGRect,index:Int) {
        super.init(frame: frame)
        self.btnframe = btnframe
        self.index = index
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  setupUI() {
        let bgView = UIView(frame: UIScreen.main.bounds)

        bgView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue:1.0, alpha: 0.2)
        let tap = UITapGestureRecognizer(target: self, action:  #selector(bgViewTapGesture(tap:)))
        bgView.addGestureRecognizer(tap)
        let btn = UIButton(frame: CGRect(x: self.btnframe.origin.x-105, y: self.btnframe.origin.y, width: 100, height: self.btnframe.height))
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.setTitle("不感兴趣", for: .normal)
        bgView.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.addSubview(bgView)
    }
    @objc func btnClick(sender:UIButton){
        delegate?.popViewDelegate(index:index)
        self.removeFromSuperview()

    }
    @objc func bgViewTapGesture(tap:UITapGestureRecognizer){
        self.removeFromSuperview()
    }
}
