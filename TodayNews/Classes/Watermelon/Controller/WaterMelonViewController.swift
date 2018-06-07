//
//  WaterMelonViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/23.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Popover
class WaterMelonViewController: UIViewController {
    var titles = [String]()
    private lazy var childVcs=[UIViewController]()
    private lazy var pageTitleView : PageTitleView={ [weak self] in
        let config = PageTitleViewConfigure()
        let rect = CGRect(x: 0, y: 64, width: kScreenW, height: 40)
        let titleView = PageTitleView(frame: rect , titles: titles, imageName: "", config: config)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var navBar = navigationBar.loadViewFromNib()
    private lazy var pageContentView:PageContentView={ [weak self] in
        let rect = CGRect(x: 0, y: 104, width: kScreenW, height: kScreenH-104)
        
        let contentView = PageContentView(frame: rect, childVCs: childVcs, parentVC: self)
        contentView.delegate = self
        return contentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()        
        //设置ui
        setupUI()
    }
    private func setupUI(){
        //设置导航栏
        setupNav()
        //载入导航栏数据导航栏
        loadData()
    }
    private func setupNav(){
        navigationItem.titleView = navBar
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        navBar.loginSelector = {
           let vc = MineViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        navBar.releaseSelector = {
            self.setupPopView()
        }
        
    }
    //设置popView
    private func setupPopView(){
        let originX = navigationItem.titleView!.frame.width-10
        let popViewW = 150
        let popViewH = 180
        let startPoint = CGPoint(x: originX, y: 64)
        let customView = UIView(frame: CGRect(x:0 , y: 0, width: popViewW, height: popViewH))
        
        let popover = Popover()
        popover.show(customView, point: startPoint)
        
        
        let rect1 = CGRect(x: 0, y: 10, width: popViewW, height: popViewH/4)
        let btnPicture = UIButton(frame: rect1, imageName: "short_video_publish_icon_camera_24x24_", text:"发图文")
        btnPicture.tag = 1
        
        let rect2 = CGRect(x: 0, y: popViewH/4+10, width: popViewW, height: popViewH/4)
        let btnTakeVideo = UIButton(frame: rect2, imageName: "short_video_publish_icon_camera_24x24_", text:"拍小视频")
        btnTakeVideo.tag = 2
        
        let rect3 = CGRect(x: 0, y: popViewH/2+10, width: popViewW, height: popViewH/4)
        let btnUpVideo = UIButton(frame: rect3, imageName:
            "short_video_publish_icon_camera_24x24_", text:"上传视频")
        btnUpVideo.tag = 3
        
        let rect4 = CGRect(x: 0, y: popViewH/4*3+10, width: popViewW, height: popViewH/4)
        let btnQuestion = UIButton(frame: rect4, imageName: "short_video_publish_icon_camera_24x24_", text:"提问")
        btnQuestion.tag = 4
        
        btnPicture.addTarget(self, action: #selector(popViewClick(_:)), for: .touchUpInside)
        btnTakeVideo.addTarget(self, action: #selector(popViewClick(_:)), for: .touchUpInside)
        btnUpVideo.addTarget(self, action: #selector(popViewClick(_:)), for: .touchUpInside)
        btnQuestion.addTarget(self, action: #selector(popViewClick(_:)), for: .touchUpInside)
        customView.addSubview(btnPicture)
        customView.addSubview(btnTakeVideo)
        customView.addSubview(btnUpVideo)
        customView.addSubview(btnQuestion)
        
        
    }
 
    @objc func popViewClick(_ sender:UIButton){
        switch sender.tag {
        case 1:
            print(sender.tag)
        case 2:
            print(sender.tag)
        case 3:
            print(sender.tag)
        case 4:
            print(sender.tag)
        default:
            break
        }
    }
    private func  loadData(){
        NetWorkTool.loadVideoApiCategories {
            self.titles = $0.flatMap({
                $0.name
            })
            self.view.addSubview(self.pageTitleView)
            
            _ = $0.flatMap({ (newTitle)->() in
                let v = WaterMelonTVController()
                
                v.setupRefresh(with: newTitle.category)
                self.childVcs.append(v)
                
             
            })
            self.view.addSubview(self.pageContentView)
            
        }
    }

}

//MARK: - 遵守pageTitleViewDelegate，pageContentViewDelegate协议
extension WaterMelonViewController:PageTitleViewDelegate,PageContentViewDelegate{
    func pageContentView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pageTitleView.getProgressAndIndex(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    func pageTitleView(currentTapIndex: Int) {
        pageContentView.setCollectionViewOffset(currentTapIndex: currentTapIndex)
    }
    
}
