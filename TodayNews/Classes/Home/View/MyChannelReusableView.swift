//
//  MyChannelReusableView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/16.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class MyChannelReusableView: UICollectionReusableView {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.layer.borderColor = UIColor.red.cgColor
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 1
        editButton.setTitle("完成", for: .selected)
        NotificationCenter.default.addObserver(self, selector: #selector(longPressGestureHandle), name: NSNotification.Name.init("longPressGestureHandle"), object: nil)
    }
    //长按手势处理
    @objc private func longPressGestureHandle(notify:Notification){
        guard let userInfo = notify.userInfo else{return}
        editButton.isSelected = userInfo["isedit"] as! Bool
        titleLabel.text = "拖拽可以排序"
    }
    //编辑按钮点击
    @IBAction func editButtonCilck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            titleLabel.text = "拖拽可以排序"
        }else{
            titleLabel.text = "点击进入频道"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("ChannelEditEvent"), object: self, userInfo: ["isedit":sender.isSelected])
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

