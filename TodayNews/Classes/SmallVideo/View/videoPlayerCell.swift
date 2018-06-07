//
//  videoPlayerCell.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Kingfisher



class videoPlayerCell: UICollectionViewCell {
    var shareSelector:(()->())?
//    var dismiss:(()->())?
    var smallVideo = NewsModel(){
        didSet{
            commentBtn.setTitle(smallVideo.raw_data.action.commentCount, for: .normal)
            
            digBtn.setTitle(smallVideo.raw_data.action.diggCount, for: .normal)
            digBtn.setImage(UIImage(named: "hts_vp_like_24x24_"), for: .normal)
            digBtn.setImage(UIImage(named: "hts_vp_like_press_24x24_"), for: .selected)
            iamgeView.image = nil
            nameLbel.text = smallVideo.raw_data.user.info.name
            avatorView.kf.setImage(with: URL(string: smallVideo.raw_data.user.info.avatar_url))
            vImageVIew.isHidden = !smallVideo.raw_data.user.info.user_verified
            
            titleLabel.attributedText = smallVideo.raw_data.attrbutedText
            concernBtn.isSelected = smallVideo.raw_data.user.relation.is_following
        }
    }
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(nameAndAvatorGes(sender:)))
        avatorView.addGestureRecognizer(tap)
        nameLbel.addGestureRecognizer(tap)
        avatorView.layer.masksToBounds = true
        avatorView.layer.cornerRadius = 25
        
        concernLabel.layer.cornerRadius = 10
        concernLabel.layer.masksToBounds = true
        
        writeCommentLabel.layer.cornerRadius = 10
        writeCommentLabel.layer.masksToBounds = true
    }
    @objc func nameAndAvatorGes(sender:UITapGestureRecognizer){
        print("userInfoClick")
    }
   
    @IBAction func concernBtn(_ sender: UIButton) {
        print("concernClick")
    }
    @IBAction func writeCommentBtn(_ sender: UIButton) {
        print("writeCommentBtnClick")
    }
    @IBAction func commentBtn(_ sender: UIButton) {
        print("commentBtnClick")
    }
    @IBAction func digBtn(_ sender: UIButton) {
         print("digBtnClick")
    }
    @IBAction func shareBtn(_ sender: UIButton) {
        shareSelector!()
    }
    @IBAction func titleBtn(_ sender: UIButton) {
        print("titleBtnClick")
    }
    @IBAction func closeBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SmallVideoCloseBtn"), object: self)
    }
    
    
    @IBOutlet weak var digBtn: UIButton!
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var vImageVIew: UIImageView!
    @IBOutlet weak var concernLabel: UIButton!
    @IBOutlet weak var avatorView: UIImageView!
    @IBOutlet weak var nameLbel: UILabel!
    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var writeCommentLabel: UIButton!
}
