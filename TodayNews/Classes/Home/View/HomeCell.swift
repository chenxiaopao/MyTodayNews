//
//  HomeCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
private let kRightImageViewW:CGFloat = kScreenW*0.28
private let kMiddleViewH:CGFloat = kScreenW*0.5

class HomeCell: UITableViewCell {
    @IBOutlet weak var righImageViewWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabelLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var topImageViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightButtonWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var middleViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var AdOrHotLabelWidthConstraints: NSLayoutConstraint!
    var aNews = NewsModel(){
        didSet{
            middleView.isHidden = false
            
            downloadButton.setImage(nil, for: .normal)
            topImageView.image = nil
            rightImageView.image = nil
            videoImageButton.setImage(nil, for: .normal)
            
            if middleView.subviews.count != 0 { videoImageButton.removeFromSuperview()
                collectionView.removeFromSuperview()
            }
           
            bottomViewHeightConstraints.constant = 0
            downloadButton.setTitle("", for: .normal)
//            标题
            titleLabel.text = aNews.title
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.numberOfLines = 0
//            用户名
            if aNews.media_name != ""{
                NameLabel.text = aNews.media_name
            }else if aNews.media_info.media_id != 0{
                NameLabel.text = aNews.media_info.name
            }else if aNews.user_info.user_id != 0{
                NameLabel.text=aNews.user_info.name
            }
//            评论数
            commentCoutLabel.text = aNews.comment_count == 0 ? "" : aNews.commentCount+"评论"
//            发表时间
            publishTimeLabel.text = aNews.publishTime
//            广告标签
            adOrHotLabel.textColor = UIColor.red
            adOrHotLabel.layer.borderColor = UIColor.red.cgColor
            adOrHotLabel.text = aNews.label
            if aNews.hot{
                adOrHotLabel.text = "热"
               
                AdOrHotLabelWidthConstraints.constant = 20
            }else if aNews.is_stick || aNews.label == "直播" || aNews.label == "影视"{
                AdOrHotLabelWidthConstraints.constant = 32
                nameLabelLeadingConstraints.constant  = 15
                
            }else if aNews.label_style == .ad {
                adOrHotLabel.textColor = UIColor.blue
                adOrHotLabel.layer.borderColor = UIColor.blue.cgColor
               AdOrHotLabelWidthConstraints.constant = 32
                if aNews.sub_title != ""{
                    subTitleLabel.text = aNews.sub_title
                    bottomViewHeightConstraints.constant = 40
                    downloadButton.setTitle("立即下载", for: .normal)
                }
            }else{
                adOrHotLabel.text = ""
                AdOrHotLabelWidthConstraints.constant = 0
                nameLabelLeadingConstraints.constant  = 0
            }
            
//            视频判断
            if aNews.video_duration != 0 && aNews.has_video{//有视频
                if aNews.video_style == 0{//右 侧有图
                    
                  
                    if let image = aNews.image_list.first{
                        rightImageView.kf.setImage(with: URL(string: image.urlString))
                      
                    }else if aNews.middle_image.url.length > 0{
                        rightImageView.kf.setImage(with: URL(string:aNews.middle_image.urlString))
                    
                    }else if let largeImage = aNews.large_image_list.first{
                          rightImageView.kf.setImage(with: URL(string: largeImage.urlString)!)
                 
                    }else{
                        return
                    }
                    
                    rightTimeButton.setTitle(aNews.videoDuration, for: .normal)
                    rightButtonWidthConstraints.constant = 50
                    righImageViewWidthConstraints.constant = kRightImageViewW
                 

                }else if aNews.video_style == 2{//大图

                    middleViewHeightConstraints.constant = kMiddleViewH
                    videoImageButton.frame = CGRect(x: 0, y: 0, width: middleView.frame.width, height: kMiddleViewH)
                    if let largeImage = aNews.large_image_list.first {
                        videoImageButton.setImage(UIImage(named: "video_play_icon_44x44_"), for: .normal)
                        videoImageButton.kf.setBackgroundImage(with: URL(string: largeImage.urlString)!, for: .normal)
                       
                    }
                    middleView.addSubview(videoImageButton)
                    initializeRightImageView()
                }
            }else{//没有视频
                
                if aNews.middle_image.url != "" && aNews.image_list.count == 0{
                    rightImageView.kf.setImage(with: URL(string:aNews.middle_image.urlString))
                    righImageViewWidthConstraints.constant = kRightImageViewW
                   
                }else {
                    middleView.isHidden = true
                    //MARK: - ??????
                    initializeRightImageView()
                    if aNews.image_list.count == 1{//右侧显示
                        rightImageView.kf.setImage(with: URL(string:aNews.image_list.first!.urlString))
                       righImageViewWidthConstraints.constant = kRightImageViewW
                        middleView.isHidden = false

                    }else if aNews.image_list.count > 1{
//                        middleView.isHidden = true
                        middleViewHeightConstraints.constant = image3Width
                        middleView.addSubview(collectionView)
                        collectionView.images = aNews.image_list
                        middleView.isHidden = false
                    }
                }
            }
            
            
            
            layoutIfNeeded()
        }
    }
    
    private func initializeRightImageView(){
        righImageViewWidthConstraints.constant = 0
        rightButtonWidthConstraints.constant = 0
        rightTimeButton.setTitle("", for: .normal)
    }
    
    private lazy var videoImageButton:UIButton = {
        let videoButton = UIButton()
        return videoButton
    }()
    
    @IBAction func AddNextPageButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func downloadButtonClick(_ sender: UIButton) {
    }

    private lazy var collectionView:HomeImageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: image3Width, height: image3Width-10)
        
        let frame = CGRect(x: 0, y: 0, width: kScreenW-30, height: image3Width)
        let collectionView = HomeImageCollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
       
    }()

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var adOrHotLabel: UILabel!
    @IBOutlet weak var addNextPageButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentCoutLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var rightTimeButton: UIButton!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
