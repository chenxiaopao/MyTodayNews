//
//  recordVideoViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/12.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class recordVideoViewController: UIViewController {
    override var prefersStatusBarHidden: Bool{
        return true
    }
    var defaultFirst:Bool = true
    private lazy var bottomView:PageTitleView={
        let titles = ["相册","拍摄"]

        let rect = CGRect(x: 0, y: kScreenH-40, width: kScreenW, height: 40)
        let labelWidth = "相册".calculateWidthWithString(font: UIFont.systemFont(ofSize: 16))
        let marginWidth:CGFloat = (kScreenW-labelWidth*2)/3
        let config = PageTitleViewConfigure(kLabelMarginWidth: marginWidth, kIsScroll: false, kIsDefaultFisrtIndex: true)
        let bottomView = PageTitleView(frame:rect, titles: titles, imageName: "", config: config)
        bottomView.backgroundColor = UIColor.clear
        bottomView.delegate = self
        return bottomView
    }()
    private lazy var contentView:PageContentView={
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.red
        var vcs = [UIViewController]()
        vcs.append(vc)
        let record = RecordController()
        vcs.append(record)
        let config = PageContentViewConfigure(kIsDefaultFisrtIndex: true)
        let contentV = PageContentView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), childVCs: vcs, parentVC: self,config:config)
        contentV.delegate = self
        return contentV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        view.addSubview(bottomView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension recordVideoViewController:PageTitleViewDelegate{
    func pageTitleView(currentTapIndex: Int) {
        contentView.setCollectionViewOffset(currentTapIndex: currentTapIndex)
    }
}

extension recordVideoViewController:PageContentViewDelegate{
    func pageContentView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        bottomView.getProgressAndIndex(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}
