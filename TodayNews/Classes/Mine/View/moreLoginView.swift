//
//  moreLoginView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/18.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class moreLoginView: UIView ,NibLoadable{
    override func awakeFromNib() {
        phoneTextField.becomeFirstResponder()
        self.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH-20)
        modifyPassword.isHidden = true
        topCloseButton.isHidden = true
        bottomCloseButton.isHidden = true
        bottomMiddleLine.isHidden = true
        topLabel.layer.cornerRadius = 20
        topLabel.layer.borderColor = UIColor.darkGray.cgColor
        topLabel.layer.borderWidth = 0.5
        bottomLabel.layer.cornerRadius = 20
        bottomLabel.layer.borderWidth = 0.5
        bottomLabel.layer.borderColor = UIColor.darkGray.cgColor
        LoginButton.layer.cornerRadius = 10
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .numberPad
        phoneTishiLabel.isHidden = true
    }
    
    //关闭页面按钮
    @IBAction func closeButton(_ sender: UIButton) {
        MoreLoginViewAnimate(originY: kScreenH)
    }
    private var random:Int = 0
    private var phoneNumber:String = ""
    //发送验证码按钮
    @IBAction func sendCaptchaButton(_ sender: UIButton) {
        phoneTextField.resignFirstResponder()
        captcha.becomeFirstResponder()
        let regex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: phoneTextField.text!)
        if  phoneTextField.text!.lengthOfBytes(using: .utf8) != 0 && isValid{
            captchaButtonWidth.constant = 100
            sendCaptchaButtn.setTitleColor(UIColor.lightGray, for: .normal)
            sendCaptchaButtn.setTitle("重新发送\(remainTime)秒", for: .normal)
            sendCaptchaButtn.isEnabled = false
            setTimer()
            random = Int(arc4random()%8999) + 1000
            let str = "code=\(random)"
            let captcha = str.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
            print(random)
            NetWorkTool.getCaptcha(phoneNumber: phoneTextField.text!,captcha:captcha!) {
                self.phoneNumber = $0
            }
            

        }else{
            phoneTishiLabel.isHidden = false
        }
        
    }
    private var remainTime = 60
    var timer : Timer!
    // 定时器
    private func setTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(cutDown), userInfo: nil, repeats: true)
    }
    @objc private func cutDown(){
        remainTime-=1
        UIView.performWithoutAnimation {
            CATransaction.setDisableActions(true)
            sendCaptchaButtn.setTitle("重新发送\(remainTime)秒", for: .normal)
            CATransaction.commit()
            
        }
        if remainTime == 0 {
           resetTimer()
        }
        
    }
    //移除定时器，重置参数
    open func resetTimer(){
        if let timer = timer{
            timer.invalidate()
        }
        phoneTextField.text = ""
        captcha.text = ""
        self.sendCaptchaButtn.isEnabled = true
        self.sendCaptchaButtn.setTitle("发送验证码", for: .normal)
        self.sendCaptchaButtn.setTitleColor(UIColor.black, for: .normal)
        captchaButtonWidth.constant = 80
    }
    //修改密码按钮
    @IBAction func modifyButton(_ sender: UIButton) {
    }
    //登陆按钮
    @IBAction func LoginButton(_ sender: UIButton) {

        if phoneTextField.text! == phoneNumber && random == Int(captcha.text!){
            if !OauthTable().isExist(uniqueId:phoneNumber){
                //提高默认的用户名
                let rand = arc4random()%1000+1
                let username = "用户\(rand)"
                //提高默认头像
                let image = UIImage(named: "home_no_login_head")!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AvatorChange"), object: self, userInfo: ["avator":image])
                //插入数据
                UserTable().insert(username,avtor: image.datatypeValue, phoneNumber: phoneNumber)
                UserTable().queryAll()
                let id = UserTable().getIdByPhoneNumber(phoneNumber: phoneNumber)
                OauthTable().insert(phoneNumber, logintype: .telePhone, Id: id)
                
            }else{
                
            }

            let id = UserTable().getIdByPhoneNumber(phoneNumber: phoneNumber)
            UserDefaults.standard.set(true, forKey: "isLogin")
            UserDefaults.standard.set(id, forKey: "id")
            UserDefaults.standard.set(phoneNumber, forKey: "uniqueId")
            MoreLoginViewAnimate(originY: kScreenH)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: self, userInfo: nil)

        }
    }
    //上下移动动画效果
    func MoreLoginViewAnimate(originY:CGFloat){
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.y = originY
        }) { (true) in
            self.resetTimer()
            self.removeFromSuperview()
            
        }
    }
    //切换登陆按钮
    private var selected:Bool = false
    @IBAction func changeLoginTypeButton(_ sender: UIButton) {
        selected = !selected
        if selected{
            topMiddleLine.isHidden = true
            sendCaptchaButtn.isHidden = true
            bottomMiddleLine.isHidden = false
            modifyPassword.isHidden = false
            tishiLabel.isHidden = true
            titleLabel.text = "账号密码登陆"
            resetTimer()
            changeLoginType.setTitle("免密码登陆", for: .normal)

        }else{
            
            tishiLabel.isHidden = false
            topMiddleLine.isHidden = false
            sendCaptchaButtn.isHidden = false
            bottomMiddleLine.isHidden = true
            modifyPassword.isHidden = true
            titleLabel.text = "登陆你的头条，精彩永不丢失"
            changeLoginType.setTitle("账号密码登陆", for: .normal)
        }
        
    }
  
    //顶部清除按钮
    @IBAction func topCloseButton(_ sender: UIButton) {
        phoneTextField.text = ""
    }
    //底部清除按钮
    @IBAction func bottomCloseButton(_ sender: UIButton) {
        captcha.text = ""
    }
    @IBOutlet weak var sendCaptchaButtn: UIButton!
    @IBOutlet weak var topMiddleLine: UIView!
    
    @IBOutlet weak var captchaButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomMiddleLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneTishiLabel: UILabel!
    @IBOutlet weak var captcha: UITextField!
   
    @IBOutlet weak var tishiLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var modifyPassword: UIButton!
    @IBOutlet weak var bottomCloseButton: UIButton!
    @IBOutlet weak var topCloseButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var changeLoginType: UIButton!
}

//MARK: - UITextFieldDelegate协议
extension moreLoginView:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        phoneTishiLabel.isHidden = true
        //限制只能输入数字，不能输入特殊字符
        let length = string.lengthOfBytes(using: .utf8)
        for index in  0..<length{
            let char = (string as NSString).character(at: index)
            if char > 57 || char < 48{
                return false
            }
        }
        
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: .utf8))! - range.length + string.lengthOfBytes(using: .utf8)
        if proposeLength > 11 {
            return false
        }
        
        return true
    }
}
