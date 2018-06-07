//
//  RecommendChannellCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/16.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class RecommendChannellCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBtn.isUserInteractionEnabled = false
        //设置阴影
        shadowView.backgroundColor = UIColor.lightText
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        shadowView.layer.shadowRadius = 1
        
        //判断字体大小
        addBtn.tintColor = UIColor.black
        let bytes = getBytesByTitle(title: addBtn.titleLabel!.text!)
        if bytes==12{
            addBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(14))
        }else if bytes >= 15{
            addBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(12))
        }

    }
  
    @IBAction func addChannelBtnClick(_ sender: UIButton) {
        
    }
    //MARK: - 获取汉子的字节数
    private func getBytesByTitle(title:String)->Int{
        return title.lengthOfBytes(using: String.Encoding.utf8)
    }
}
