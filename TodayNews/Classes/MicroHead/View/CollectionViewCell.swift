//
//  CollectionViewCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImgaeView: UIImageView!
    @IBOutlet weak var gifLabel: UILabel!
    var thumbImage = ThumbImage() {
        didSet {
            thumbImgaeView.kf.setImage(with: URL(string: thumbImage.urlString)!)
            gifLabel.isHidden = !(thumbImage.type == .gif)
        }
    }
    
    var thumb = ThumbImage()
    
    var largeImage = LargeImage() {
        didSet {
            thumbImgaeView.kf.setImage(with: URL(string: largeImage.urlString),  progressBlock: { (receivedSize, totalSize) in
                let progress = Float(receivedSize/totalSize)
                SVProgressHUD.showProgress(progress)
                SVProgressHUD.setBackgroundColor(.clear)
                SVProgressHUD.setForegroundColor(UIColor.white)
            }) { (image, error, cacheType, url) in
                if image == nil{
                    self.thumbImgaeView.kf.setImage(with:URL(string: self.thumb.urlString) )
                }
                SVProgressHUD.dismiss()
            }
            
            gifLabel.isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        thumbImgaeView.layer.borderWidth = 1
//        thumbImgaeView.layer.borderColor = UIColor.lightGray.cgColor
        thumbImgaeView.contentMode = .scaleAspectFit
        thumbImgaeView.sizeToFit()
    }

}
