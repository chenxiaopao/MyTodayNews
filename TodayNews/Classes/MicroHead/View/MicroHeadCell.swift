//
//  MicroHeadCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/4.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Kingfisher
class MicroHeadCell: UITableViewCell {
  
    var aNews = NewsModel() {
        didSet {
            print(aNews.user.avatar_url)
            avatarImageView.kf.setImage(with: URL(string: aNews.user.avatar_url))
            vImageView.isHidden = !aNews.user.user_verified
            nameLabel.text = aNews.user.name
            timeAndDescriptionLabel.text = aNews.createTime + (aNews.user.verified_content != "" ? (" · \(aNews.user.user_verified)") : "")
            likeButton.setTitle(aNews.digg_count == 0 ? "赞" : aNews.diggCount, for: .normal)
            likeButton.isSelected = aNews.user_digg
            commentButton.setTitle(aNews.commentCount, for: .normal)
            forwardButton.setTitle(aNews.forward_info.forwardCount, for: .normal)
            concernButton.isSelected = aNews.user.is_following
            areaLabel.text = (aNews.position.position != "" ? "\(aNews.position.position) · " : "" ) + aNews.readCount + "阅读 " + (aNews.brand_info != "" ? aNews.brand_info : "")
            // 显示 emoji
            contentLabel.attributedText = aNews.attributedContent
            contentLabelHeight.constant = aNews.contentH
            middleViewHeight.constant = aNews.collectionViewH

            if middleView.contains(collectionView) { collectionView.removeFromSuperview() }
            if aNews.thumb_image_list.count != 0 {
                middleView.addSubview(collectionView)
                collectionView.frame = CGRect(x: 0, y: 0, width: kScreenW-30 , height: aNews.collectionViewH)
                collectionView.thumbImage = aNews.thumb_image_list
                collectionView.largeImages = aNews.large_image_list
              
            }
            
            layoutIfNeeded()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
    }
    
    private let collectionView:MicroHeadColletionView={
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collectionV = MicroHeadColletionView(frame: CGRect(), collectionViewLayout: layout)
        collectionV.isScrollEnabled = false
        collectionV.backgroundColor = UIColor.white
        return collectionV
    }()
    /// 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// v
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 时间和描述
    @IBOutlet weak var timeAndDescriptionLabel: UILabel!
    /// 关注按钮
    @IBOutlet weak var concernButton: UIButton!
    /// 关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    /// 中间的 view
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleViewHeight: NSLayoutConstraint!
    /// 喜欢按钮
    @IBOutlet weak var likeButton: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 转发按钮
    @IBOutlet weak var forwardButton: UIButton!
    /// 位置/阅读数量
    @IBOutlet weak var areaLabel: UILabel!
    
 
    /// 底部的 view
    @IBOutlet weak var bottomView: UIView!
    
   
   
}
