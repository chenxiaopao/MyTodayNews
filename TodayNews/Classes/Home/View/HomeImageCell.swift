//
//  HomeImageCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class HomeImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    

    var image = ImageList(){
        didSet{
            imageView.kf.setImage(with: URL(string:image.urlString))
        }
    }
}
