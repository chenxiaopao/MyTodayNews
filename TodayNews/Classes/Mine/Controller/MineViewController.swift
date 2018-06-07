//
//  MineViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/18.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

private let MineTableViewCellID = "MineTableViewCell"
class MineViewController: UITableViewController {
    private lazy var headView = NoLoginHeadView.loadViewFromNib()
    private lazy var footerView:UIView={
        let height = headView.frame.height + 30 + 300
        let v = UIView(frame: CGRect(x: 0, y: height, width: kScreenW, height: kScreenH-height))
        return v
    }()
    private  let loginView = moreLoginView.loadViewFromNib()

    private lazy var backBtn:UIButton = {
        let rect = CGRect(x: 20, y: 20, width: 24, height: 24)
        let btn = UIButton(frame: rect)
        btn.tag = 22
        btn.setImage(UIImage(named:"leftbackicon_white_titlebar_24x24_"), for: .normal)
        btn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)

        return btn
    }()
    private let statusBar =  UIApplication.shared.value(forKey: "statusBar") as! UIView
    var sections = [[MyCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = headView
        //执行闭包，左边返回按钮
        headView.backBtnSelector = {
            self.navigationController?.popViewController(animated: true)
        }
        headView.moreLoginSelector={
            self.moreLoginBtn()
        }
        headView.actionSheetSelector = {
            self.setActionSheet()
        }
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MineTableViewCell", bundle: nil), forCellReuseIdentifier: MineTableViewCellID)
        NetWorkTool.loadMyCellData {
            self.sections = $0
            self.tableView.reloadData()
        }
    
    }
    //设置actionSheet
    private func setActionSheet(){
        let alert = UIAlertController(title: "设置头像", message: "以下两种方式", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: false, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "相机获取", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.videoQuality =  UIImagePickerControllerQualityType.typeHigh
                picker.allowsEditing = true
                self.present(picker, animated: false, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
    }
    //更多登陆按钮
    private func moreLoginBtn(){

        UIApplication.shared.keyWindow?.addSubview(loginView)
        UIView.animate(withDuration: 0.5) {
            self.loginView.frame.origin.y = 20
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(pan:)))
        loginView.addGestureRecognizer(pan)
    }
    //处理上下滑动
    @objc func handleSwipe(pan:UIPanGestureRecognizer){
        
        let point = pan.translation(in: self.view)
        if pan.state == .changed&&point.y>=20{
            self.loginView.frame.origin.y = point.y
        }else if pan.state == .ended{
            if let timer = loginView.timer{
                loginView.resetTimer()
            }
            if point.y>=20+(kScreenH-20)/3{
                UIView.animate(withDuration: 0.3, animations: {
                    self.loginView.frame.origin.y = kScreenH
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.loginView.frame.origin.y = 20
                })
            }
        }
    }
    @objc func backBtnClick(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        statusBar.backgroundColor = UIColor.clear
        navigationController?.isNavigationBarHidden = false
         self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
//        //获取状态栏控件
      

        statusBar.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)

        //设置tableView偏移为-20，使得背景覆盖到状态栏
//        tableView.contentOffset = CGPoint(x: 0, y: -20)
    }

        
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
extension  MineViewController{
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==1 ? 0 : 5
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 5))
        view.theme_backgroundColor = "colors.separatorViewColor"
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCellID, for: indexPath) as! MineTableViewCell
        let myCellModel = sections[indexPath.section][indexPath.row]
        cell.leftLabel.text = myCellModel.text
        cell.rightLabel.text = myCellModel.grey_text
        
        
        return cell
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            
            let totalOffset = headView.frame.height + abs(offsetY)
            let f = totalOffset / headView.frame.height
            headView.bgImageView.frame = CGRect(x: -kScreenW * (f - 1) * 0.5, y: offsetY, width: kScreenW * f, height: totalOffset-80)
            
        }
    }
}
extension MineViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        headView.avatorImageView.image = image
        UserTable().update(Id: UserDefaults.standard.value(forKey: "id") as! Int64, avtor: image.datatypeValue)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AvatorChange"), object: self, userInfo: ["avator":image])
        dismiss(animated: false, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: false, completion: nil)
    }
}
