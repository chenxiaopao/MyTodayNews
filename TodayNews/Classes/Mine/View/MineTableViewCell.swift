//
//  MineTableViewCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/19.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    /// 右边箭头
    @IBOutlet weak var rightImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        bringSubview(toFront: bottomLine)
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageView.theme_image = "images.cellRightArrow"
        bottomLine.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

    
    
}
