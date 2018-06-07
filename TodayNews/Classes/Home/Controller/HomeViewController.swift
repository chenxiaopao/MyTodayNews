//
//  HomeViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import SnapKit
import  SwiftyJSON
private let kNavTitleViewH:CGFloat = 30
private let kNavTitleViewW:CGFloat = kScreenW - 120
private let kPageTitleViewH:CGFloat = 40
private let kPageContentViewH:CGFloat = kScreenH - kNavigationBarH-kStatusBarH-kPageTitleViewH

class HomeViewController: UIViewController {
    let imageNames = ["short_video_publish_icon_camera_24x24_","short_video_publish_icon_camera_24x24_","short_video_publish_icon_camera_24x24_","short_video_publish_icon_camera_24x24_"]
    let titleNames = ["发图文","拍小视频","上传视频","提问"]

    var navBarStr : String!
    let vc = SearchViewController()
    var navBarStrArr=[String](){
        didSet{
            vc.suggestArr = navBarStrArr
        }
    }
    var leftBarButtonView:UIView!
    var rect:CGRect!
    var isSecondLaunch = false
    private lazy var titles: [String] = [String]()
    private lazy var childVcS:[UIViewController] = [UIViewController]()
    private var pageTitleView:PageTitleView!
    private lazy var pageContentView : PageContentView={ [weak self] in
        let rect = CGRect(x: 0, y: kNavigationBarH+kStatusBarH+kPageTitleViewH, width: kScreenW, height: kPageContentViewH)
       
        let pageContentView = PageContentView(frame: rect, childVCs: childVcS, parentVC: self)
        pageContentView.delegate = self
        return pageContentView
    }()
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorAvatorEvent), name: NSNotification.Name(rawValue: "AvatorChange"), object: nil)
//        let s = SQLiteManager.shared

//        print(String.init(format: "%018p", unsafeBitCast(s, to: Int.self)))
//        let q = SQLiteManager.shared
//        print(String.init(format: "%018p", unsafeBitCast(q, to: Int.self)))
        //设置UI
        
        setupUI()
    }
    @objc func MonitorAvatorEvent(noti:Notification){
        let userInfo = noti.userInfo as! [String:UIImage]
        let image = userInfo["avator"]!
         let rect = CGRect(x: 0, y: 0, width: 44, height: 44)
        let View = UIView(frame: rect)
        let imageView = UIImageView(image:  image)
        View.addSubview(imageView)
        View.layer.cornerRadius = 22
        View.layer.masksToBounds = true
        imageView.frame = View.frame
        imageView.contentMode = .scaleToFill
        leftBarButtonView = View
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftButtonClick(tap:)))
        leftBarButtonView.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)

    }
}


//MARK: - 设置UI
extension HomeViewController{
    private func setupUI(){
        
        //设置导航栏
        setupNavigationBar()
    }
    private func setupPageViewAndLoadData(){
        
        rect = CGRect(x: 0, y: kNavigationBarH+kStatusBarH, width:      kScreenW, height: kPageTitleViewH)
        //        第一次启动就从网络获取标题，否则从本地获取,当健不存在时，isSecondLaunch为false
        isSecondLaunch = UserDefaults.standard.bool(forKey: kSecondLaunchKey)
        //顶部标题数据
        NetWorkTool.loadHomeNewTitleData {
            if !self.isSecondLaunch {
                self.titles = $0.flatMap({ $0.name })
                UserDefaults.standard.set(self.titles, forKey: kMyChannelTitleKey)
            }else{
                self.titles = UserDefaults.standard.array(forKey: kMyChannelTitleKey) as! [String]
            }
            
            let config = PageTitleViewConfigure()
            if self.pageTitleView != nil{
                self.pageTitleView.removeFromSuperview()
            }
            self.pageTitleView = PageTitleView(frame: self.rect, titles: self.titles,imageName:"add_channel_titlbar_thin_new_16x16_",config:config)
            self.pageTitleView.delegate = self
            self.view.addSubview(self.pageTitleView)
           
            $0.flatMap({ (newsTitle) -> () in
                switch newsTitle.category{
                default :
                    
                    let homeRecommendVc = HomeRecommendController()
                    homeRecommendVc.setupRefresh(with: newsTitle.category)
                    self.addChildViewController(homeRecommendVc)
                    break
                    
                }
            })
            self.pageContentView.childVcs = self.childViewControllers
            //添加pageContentView
            self.view.addSubview(self.pageContentView)
            
        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
        //加载数据
        setupPageViewAndLoadData()
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
         self.navigationController?.navigationBar.isTranslucent  = true
    }
    //MARK: - 设置导航栏
    private func setupNavigationBar(){
        
        let rect = CGRect(x: 0, y: 0, width: 44, height: 44)

        if UserDefaults.standard.bool(forKey: "isLogin"){
            usr = UserTable().queryRowById(Id: UserDefaults.standard.value(forKey: "id") as! Int64)
            let View = UIView(frame: rect)
            let imageView = UIImageView(image:  UIImage.fromDatatypeValue(usr.avator))
            View.addSubview(imageView)
            View.layer.cornerRadius = 22
            View.layer.masksToBounds = true
            imageView.frame = View.frame
            imageView.contentMode = .scaleToFill
            leftBarButtonView = View

        }else{
            leftBarButtonView = LeftBarButtonView(frame: rect, imageName: "mine_tabbar_32x32_", labelText: "未登录")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftButtonClick(tap:)))
        leftBarButtonView.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"icon_release_tabbar_line"), for: .normal)
        btn.addTarget(self, action:#selector(rightButtonClick(sender:)) , for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        let titleViewFrame = CGRect(x: 0, y: 0, width: kNavTitleViewW, height: kNavTitleViewH)
        NetWorkTool.loadHomeSearchSuggestInfo {
            self.navBarStr = $0
            self.navBarStrArr = $1.compactMap({$0.word})
            let titleView = NavigationTitleView(frame: titleViewFrame,title:self.navBarStr)
            titleView.titleViewSelector = {
                self.vc.hidesBottomBarWhenPushed = true
                self.vc.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(self.vc, animated: true)
            }
             self.navigationItem.titleView = titleView
        }
       
        
       
    }
  
    //导航栏左边点击事件
    @objc func leftButtonClick(tap:UITapGestureRecognizer){
        let vc = MineViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //导航栏右边点击事件
    @objc func rightButtonClick(sender:UIButton){
        
        let size = CGSize(width: 130, height: 150)
        let point = CGPoint(x: kNavTitleViewW+90, y: 64)
        let popView = PopView(popViewSize: size, arrowPoint: point, titleNames: titleNames, imageNames: imageNames)
        popView.delegate = self
//        UIApplication.shared.keyWindow?.addSubview(popView)
        popView.showPopView()
    }
    
}

//MARK: - 遵守PageTitleViewDelegate
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleViewSetRightBtnVC() {
        
        let vc = AddChannelViewController()
        vc.MyTitleArr = UserDefaults.standard.array(forKey: kMyChannelTitleKey) as! [String]
        
        self.present(vc, animated: true, completion: nil)
    }
    func pageTitleView(currentTapIndex: Int) {
        UIView.performWithoutAnimation {
            pageContentView.setCollectionViewOffset(currentTapIndex: currentTapIndex)
            
        }
        
    }
}
//MARK: - 遵守PageContentViewDelegate
extension HomeViewController:PageContentViewDelegate{
    func pageContentView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pageTitleView.getProgressAndIndex(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}
//MARK: - PopViewDelegate
extension HomeViewController:PopViewDelegate{
    func popView(_ popViewCellBtn: UIButton, popTag: Int) {
        let alert = UIAlertController(title: "未做处理", message: "谢谢关注", preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: false, completion: nil)
    }
}
