//
//  leftBarButtonView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/18.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class LeftBarButtonView: UIView {
    var imageName:String
    var labelText:String
    init(frame:CGRect,imageName:String,labelText:String) {
        self.imageName = imageName
        self.labelText = labelText
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){

        //在view中添加imageView
        let imageView = UIImageView(image: UIImage(named: imageName))
        self.addSubview(imageView)
        //在view中添加label
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = labelText
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        self.addSubview(label)
        
        //设置约束
        label.snp.makeConstraints { (make) in
            make.height.equalTo(5)
            make.bottom.equalTo(-5)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(label.snp.top)
            
        }
    }
}
