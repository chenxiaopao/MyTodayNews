//
//  SmallVideoViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/4.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class SmallVideoViewController: UIViewController {

    private lazy var  titleNames = [String]()
    private lazy var  childVcs = [UIViewController]()
    private lazy var pageTitleView:PageTitleView = {
        let config = PageTitleViewConfigure(kIsScroll: false)
        let pageTitleView = PageTitleView(frame:             (self.navigationController?.navigationBar.frame)!, titles: titleNames,imageName:"short_video_publish_icon_camera_24x24_",config:config)

        pageTitleView.delegate = self
        return pageTitleView
    }()
    private lazy var pageContentView : PageContentView={ [weak self] in
        let rect = CGRect(x: 0, y: kStatusBarH+kNavigationBarH, width: kScreenW, height: kScreenH-kStatusBarH-kNavigationBarH)
        let pageContentView = PageContentView(frame: rect, childVCs: childVcs, parentVC: self)
        pageContentView.delegate = self
        return pageContentView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        NetWorkTool.loadSmallVideoCategories {
            self.titleNames = $0.flatMap({$0.name})
            self.navigationController?.navigationBar.isHidden = true
            
            self.view.addSubview(self.pageTitleView)
           
            
            $0.flatMap({ (newsTitle) -> () in
                let Vc = SmallVIdeoCategoryController()
                Vc.newsTitle = newsTitle
                self.childVcs.append(Vc)
            })
            self.view.addSubview(self.pageContentView)
           
            
        }
        
    }
}

//MARK: - 遵守PageTitleViewDelegate
extension SmallVideoViewController:PageTitleViewDelegate{
   
    func pageTitleView(currentTapIndex: Int) {
        pageContentView.setCollectionViewOffset(currentTapIndex: currentTapIndex)
    }
    func pageTitleViewSetRightBtnVC() {
        let vc = recordVideoViewController()
        present(vc, animated: true, completion: nil)
    }
}
//MARK: - 遵守PageContentViewDelegate
extension SmallVideoViewController:PageContentViewDelegate{
    func pageContentView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pageTitleView.getProgressAndIndex(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
}

