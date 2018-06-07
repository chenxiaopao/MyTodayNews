//
//  PageContentView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/20.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
protocol PageContentViewDelegate:class {
    func pageContentView(progress:CGFloat,currentIndex:Int,targetIndex:Int)
}
class PageContentViewConfigure{
    var kIsDefaultFisrtIndex : Bool 
    init(kIsDefaultFisrtIndex:Bool=false) {
        self.kIsDefaultFisrtIndex = kIsDefaultFisrtIndex
    }
}
private let contentID = "contentID"
class PageContentView:UIView{
    //如果是titleView点击事件，不相应scrollViewDidScroll方法
    private var isTap:Bool = false
    weak var delegate:PageContentViewDelegate?
    private var startContentOffsetX:CGFloat = 0
    var childVcs:[UIViewController]
    private var parentVc:UIViewController
    var config : PageContentViewConfigure?
    //懒加载属性
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let contentView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "contentID")
        return contentView
    }()
    init(frame:CGRect,childVCs:[UIViewController],parentVC:UIViewController?,config:PageContentViewConfigure?=nil) {
        self.parentVc = parentVC!
        self.childVcs = childVCs
        self.config = config
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 设置UI
extension PageContentView{
    private func setupUI(){
        //添加子控制器
        for childVC in childVcs{
            parentVc.addChildViewController(childVC)
            childVC.view.frame = self.bounds
        }
        //添加collectionView
        self.addSubview(collectionView)
        if let config = config{
            if config.kIsDefaultFisrtIndex{
                let offSetX = CGFloat(1)*self.bounds.width
                collectionView.setContentOffset(CGPoint(x:offSetX,y:0), animated: true)
            }
        }
        
        
    }
}
//MARK: - 遵守UICollectionViewDelegateFlowLayout，UICollectionViewDataSource协议
extension PageContentView:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentID", for: indexPath)
        //由于cell的循环利用，在返回之前先移除
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let view = childVcs[indexPath.item].view
        view?.frame = cell.contentView.bounds
        cell.contentView.addSubview(view!)
      
        return cell
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffsetX=scrollView.contentOffset.x
        //开始拖动，就可以执行scrollViewDidScroll方法
        isTap = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isTap{return}
        
        var progress:CGFloat = 0
        var targetIndex:Int = 0
        var currentIndex:Int = 0
        let contentW = self.bounds.width
        let currentOffsetX = scrollView.contentOffset.x
        
        
        progress = abs(currentOffsetX - startContentOffsetX)/contentW
        
        currentIndex = Int(startContentOffsetX/contentW)
        
        if currentOffsetX > startContentOffsetX{//向左滑动
            
            targetIndex = currentIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
        }else if currentOffsetX < startContentOffsetX{//向右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0{
                targetIndex = 0
            }
        }else{//回到原处
            progress = 0
            targetIndex = currentIndex
        }
//        print("progress:\(progress),,currentIndex:\(currentIndex),,target:\(targetIndex)")
        
        delegate?.pageContentView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
}

//MARK: - 暴露方法
extension PageContentView{
    func setCollectionViewOffset(currentTapIndex:Int){
        isTap = true
        let offSetX = CGFloat(currentTapIndex)*self.bounds.width
        self.collectionView.setContentOffset(CGPoint(x:offSetX,y:0), animated: false)
     
        
    }
}
