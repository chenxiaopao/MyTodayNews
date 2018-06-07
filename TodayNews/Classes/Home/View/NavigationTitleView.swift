//
//  NavigationTitleself.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
class NavigationTitleView:UIView{
    var titleViewSelector: (()->())?
    var title : String!
    init(frame: CGRect,title:String) {
        super.init(frame: frame)
        self.title = title
        let tap = UITapGestureRecognizer(target: self, action: #selector(titleViewCilck(tap:)))
        self.addGestureRecognizer(tap)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
//MARK: - 设置UI
extension NavigationTitleView{
    private func setupUI(){
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        let searchW :CGFloat = 20
        let searchMargin:CGFloat = 5
        let searchImageView = UIImageView(image: UIImage(named:"search_topic"))
        searchImageView.frame = CGRect(x: 0, y: searchMargin, width: searchW, height: searchW)
        self.addSubview(searchImageView)
        
        let label = UILabel(frame: CGRect(x: searchW+searchMargin, y: 10, width: frame.width-searchW, height: 10))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.darkGray
        if title != ""{
            label.text = title
        }else{
            label.text = "搜你想搜的"
        }
        
        self.addSubview(label)
    }
    @objc private func titleViewCilck(tap:UITapGestureRecognizer){
        titleViewSelector!()
    }
}
