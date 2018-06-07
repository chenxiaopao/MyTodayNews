//
//  WaterMelonTVCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import  Kingfisher
class WaterMelonTVCell: UITableViewCell {

    var bgBtnSelector:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        playOrPauseButton.isHidden = true
        adButton.layer.borderWidth = 1
        adButton.layer.borderColor = UIColor.blue.cgColor
        adButton.layer.cornerRadius = 3
       
        avatorButton.layer.cornerRadius = 25
        avatorButton.layer.masksToBounds = true
        shareStackView.isHidden = true
        concernButton.setImage(nil, for: .selected)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        timeLabel.layer.cornerRadius = 10
        timeLabel.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
    }
    
    var video = NewsModel(){
        didSet{
            titleLabel.text = video.title
            countLabel.text = video.video_detail_info.videoWatchCount + "次播放"
            avatorButton.kf.setImage(with: URL(string:
                video.user_info.avatar_url), for: .normal)
            vipImageView.isHidden = !video.user_info.user_verified
            concernButton.isSelected = video.user_info.follow
            bgButton.kf.setBackgroundImage(with: URL(string: video.video_detail_info.detail_video_large_image.urlString)!, for: .normal)
            timeLabel.text = video.videoDuration
            commentButton.setTitle(video.commentCount, for: .normal)
            concernButton.isHidden = video.label_style == .ad
            commentButton.isHidden = video.label_style == .ad
            detailButton.setTitle((video.ad_button.button_text == "" ? "查看详情" : video.ad_button.button_text), for: .normal)
            nameLabel.text = video.user_info.name
            if video.label_style == .ad {
                nameLabel.text = video.app_name != "" ? video.app_name : video.ad_button.app_name
            }
            adButton.isHidden = video.label_style != .ad
            detailButton.isHidden = video.label_style != .ad
        }
    }
    
    //评论按钮
    @IBOutlet weak var commentButton: UIButton!
    @IBAction func commentBtnClick(_ sender: UIButton) {
    }
    //更多按钮
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreButtonClick(_ sender: UIButton) {
    }
    //详情按钮
    @IBOutlet weak var detailButton: UIButton!
    @IBAction func detailBtnClick(_ sender: UIButton) {
    }
    //关注按钮
    @IBOutlet weak var concernButton: UIButton!
    @IBAction func concernBtnClick(_ sender: UIButton) {
    }
    //用户名label
    @IBOutlet weak var nameLabel: UILabel!
    //广告按钮
    @IBOutlet weak var adButton: UIButton!
    @IBAction func adButtonClick(_ sender: UIButton) {
    }
    //分享堆栈视图
    @IBOutlet weak var shareStackView: UIStackView!
    //时间label
    @IBOutlet weak var timeLabel: UILabel!
    //VIP图像
    @IBOutlet weak var vipImageView: UIImageView!
    //头像按钮
    @IBOutlet weak var avatorButton: UIButton!
    @IBAction func avatorButtonClick(_ sender: UIButton) {
    }
    //播放按钮
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBAction func playButtonClick(_ sender: UIButton) {
    }
    
    //背景图片按钮
    @IBAction func bgButtonClick(_ sender: UIButton) {
        bgBtnSelector!()
    }
    @IBOutlet weak var bgButton: UIButton!
    //播放次数
    @IBOutlet weak var countLabel: UILabel!
    //标题s
    @IBOutlet weak var titleLabel: UILabel!
}

extension WaterMelonTVCell{
     /// 设置当前 cell 的属性
    func showSubViews(){
        titleLabel.isHidden = false
        countLabel.isHidden = false
        timeLabel.isHidden = false
        avatorButton.isHidden = false
        vipImageView.isHidden = !video.user_verified
        nameLabel.isHidden = false
        shareStackView.isHidden = true
    }
    
    /// 视频播放时隐藏 cell 的部分子视图
    func hideSubviews() {
        titleLabel.isHidden = true
        countLabel.isHidden = true
        timeLabel.isHidden = true
        vipImageView.isHidden = true
        avatorButton.isHidden = true
        nameLabel.isHidden = true
        shareStackView.isHidden = false
    }
}
