//
//  MyChannelCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/15.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class MyChannelCell: UICollectionViewCell {
    
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var closeImage: UIImageView!
    var isEdit = false {
        didSet{
            
            closeImage.isHidden = !isEdit
            if closeImage.isHidden {
                channelBtn.isUserInteractionEnabled = true
            }else{
                channelBtn.isUserInteractionEnabled = false
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeImage.layer.cornerRadius = 5
        closeImage.layer.masksToBounds = true
        closeImage.backgroundColor = UIColor.white
        closeImage.isHidden = true
        channelBtn.tintColor = UIColor.black
    

    }

    @IBAction func channelBtnClick(_ sender: UIButton) {
//        print(1)
    }
}
