//
//  NoLoginHeadView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/19.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

var usr : user!
class NoLoginHeadView: UIView,NibLoadable {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    /// 手机按钮
    @IBOutlet weak var mobileButton: UIButton!
    /// 微信按钮
    @IBOutlet weak var wechatButton: UIButton!
    /// QQ 按钮
    @IBOutlet weak var qqButton: UIButton!
    
    /// 更多登录方式按钮
    @IBOutlet weak var moreLoginButton: UIButton!
    /// 收藏按钮
    @IBOutlet weak var favoriteButton: UIButton!
    /// 历史按钮
    @IBOutlet weak var historyButton: UIButton!
    /// 日间/夜间 按钮
    @IBOutlet weak var dayOrNightButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var nameLabe: UILabel!
    //用户对象
    
    var actionSheetSelector:(()->())?
    var moreLoginSelector:(()->())?
    var backBtnSelector:(()->())?
    //MARK:- 获取view 所在的控制器
    func getViewController()->(UIViewController){
        //1.通过响应者链关系，取得此视图的下一个响应者
        var next: UIResponder?
        next = self.next!
        repeat{
            //2.判断响应者对象是否是视图控制器类型
            if (next as? MineViewController) != nil{
                return (next as! MineViewController)
            }else{
                next = self.next!
            }
        }while next != nil
        return UIViewController()
    }
    //点击登陆后处理
    @objc func loginSuccessEvent(noti:Notification){
        if UserDefaults.standard.bool(forKey: "isLogin"){
            usr = UserTable().queryRowById(Id: UserDefaults.standard.value(forKey: "id") as! Int64)
            wechatButton.isHidden = true
            moreLoginButton.isHidden  = true
            mobileButton.isHidden = true
            titleLabel.isHidden = true
            qqButton.isHidden = true
            nameLabe.text = usr.userName
            nameLabe.isHidden = false
            exitButton.isHidden = false
            avatorImageView.image = UIImage.fromDatatypeValue(usr.avator)
            avatorImageView.isHidden = false
            
        }
    }
    //底部弹窗
    @objc func actionSheet(tap:UITapGestureRecognizer){
        actionSheetSelector!()
    }
    override func awakeFromNib() {
        avatorImageView.layer.cornerRadius = 25
        avatorImageView.layer.masksToBounds = true
        avatorImageView.isUserInteractionEnabled = true
        avatorImageView.contentMode = .scaleToFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSheet(tap: )))
        avatorImageView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessEvent(noti:)), name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        if UserDefaults.standard.bool(forKey: "isLogin"){
            usr = UserTable().queryRowById(Id: UserDefaults.standard.value(forKey: "id") as! Int64)
            wechatButton.isHidden = true
            moreLoginButton.isHidden  = true
            mobileButton.isHidden = true
            titleLabel.isHidden = true
            qqButton.isHidden = true
            nameLabe.text = usr.userName
            avatorImageView.image = UIImage.fromDatatypeValue(usr.avator)
            nameLabe.isHidden = false
            exitButton.isHidden = false
            avatorImageView.isHidden = false
        
        }else{
            exitButton.isHidden = true
            nameLabe.isHidden = true
            avatorImageView.isHidden = true
        }
        dayOrNightButton.isSelected = UserDefaults.standard.bool(forKey: isNight)
        mobileButton.theme_setImage("images.loginMobileButton", forState: .normal)
        wechatButton.theme_setImage("images.loginWechatButton", forState: .normal)
        qqButton.theme_setImage("images.loginQQButton", forState: .normal)
        

        /// 设置主题
        theme_backgroundColor = "colors.cellBackgroundColor"
        favoriteButton.theme_setImage("images.mineFavoriteButton", forState: .normal)
        historyButton.theme_setImage("images.mineHistoryButton", forState: .normal)
        dayOrNightButton.theme_setImage("images.dayOrNightButton", forState: .normal)
        dayOrNightButton.setTitle("夜间", for: .normal)
        dayOrNightButton.setTitle("日间", for: .selected)        
        moreLoginButton.theme_setTitleColor("colors.moreLoginTextColor", forState: .normal)
        favoriteButton.theme_setTitleColor("colors.black", forState: .normal)
        historyButton.theme_setTitleColor("colors.black", forState: .normal)
        dayOrNightButton.theme_setTitleColor("colors.black", forState: .normal)
     
        titleLabel.theme_textColor = "colors.moreLoginTextColor"
    }
    
    
    @IBAction func PhoneBtn(_ sender: UIButton) {
        
    }
    
    
    @IBAction func exitButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "uniqueId")
        wechatButton.isHidden = false
        moreLoginButton.isHidden  = false
        mobileButton.isHidden = false
        titleLabel.isHidden = false
        qqButton.isHidden = false
        nameLabe.isHidden = true
        exitButton.isHidden = true
        avatorImageView.isHidden = true

    }
    @IBAction func WeChatBtn(_ sender: UIButton) {
    }
    @IBAction func QQBtn(_ sender: UIButton) {
    }
    @IBAction func NightBtn(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: isNight)
        MyTheme.switchNight(sender.isSelected)
    }
    
    @IBAction func HistoryBtn(_ sender: UIButton) {
        
    }
    @IBAction func OtherLoginBtn(_ sender: UIButton) {
        moreLoginSelector!()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        backBtnSelector!()
    }
    
    @IBAction func FavoriteBtn(_ sender: UIButton) {
    }
    
}

