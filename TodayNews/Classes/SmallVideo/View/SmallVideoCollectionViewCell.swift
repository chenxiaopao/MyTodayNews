//
//  SmallVideoCollectionViewCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/4.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Kingfisher
protocol SmallVideoCollectionViewCellDelegate:class {
    func collectionCellRightClose(btn:UIButton,itemIndex index :Int)
}
class SmallVideoCollectionViewCell: UICollectionViewCell {
    
    var newsModel = NewsModel(){
        didSet{
            title.attributedText = newsModel.raw_data.attrbutedText
            if let largeImage = newsModel.raw_data.large_image_list.first {
                imageVIew.kf.setImage(with: URL(string: largeImage.urlString)!)
            } else if let firstImage = newsModel.raw_data.first_frame_image_list.first {
                imageVIew.kf.setImage(with: URL(string: firstImage.urlString)!)
            }
            favorCount.text = newsModel.raw_data.action.diggCount + "赞"
            
            playCount.setTitle(newsModel.raw_data.action.playCount + "次播放", for: .normal)

            
        }
    }
    var index:Int!
    weak var delegate:SmallVideoCollectionViewCellDelegate?
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var favorCount: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var playCount: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        
    }
    @IBAction func closeButton(_ sender: UIButton) {
        
        delegate?.collectionCellRightClose(btn: sender, itemIndex: index)
    }
    
    
}
