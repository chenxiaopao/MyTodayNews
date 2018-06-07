//
//  SmallVIdeoCollectionViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/4.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

private let SmallVideoCollectionViewCellID = "SmallVideoCollectionViewCellID"
private let kTabBarH:CGFloat = 49
//MARK: - SmallVIdeoCategoryController
class SmallVIdeoCategoryController: UIViewController{
    var preIndex : Int = 0
    var isDelete:Bool = false
    var endConttentOffSet:CGFloat = 0
    /// 标题
    var newsTitle = HomeNewsTitle()
    /// 刷新时间
    var maxBehotTime: TimeInterval = 0.0
    /// 视频数据
    let vc = VideoPlayerController()
    var smallVideos = [NewsModel](){
        didSet{
            
            vc.smallVideo = smallVideos
        }
    }
  
    var originY:CGFloat!
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth = (kScreenW-15)/2
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth*1.5)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
      
        let collectionVIew = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionVIew.delegate = self
        collectionVIew.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionVIew.dataSource = self
        return collectionVIew
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.addSubview(collectionView)
        originY = collectionView.frame.origin.y
        collectionView.register(UINib(nibName: "SmallVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SmallVideoCollectionViewCellID)
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.backgroundColor = UIColor.white
        
        
        setupRefresh()

    }

    // 添加刷新控件
    func setupRefresh(){
        
//        下拉刷新
        let header = RefreshHeader {
            [weak self] in
            
            NetWorkTool.loadApiNewsFeeds(category: self!.newsTitle.category, ttFrom: .enterAuto, { (maxBehotTime, newsModel) in
                if (self?.collectionView.mj_header.isRefreshing)!{
                    self?.collectionView.mj_header.endRefreshing()
                }
               
                self?.maxBehotTime = maxBehotTime
//                self?.smallVideos  += newsModel
                
                self?.smallVideos.insert(contentsOf: newsModel, at: 0)
                self?.refreshCount = newsModel.count
                self?.collectionView.reloadData()
                if !(self?.isFirst)!{
                    //先执行endRefreshing()在执行completionBlock
                    self?.collectionView.mj_header.endRefreshing(completionBlock: {
                        // 显示刷新个数
                        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 30)
                        let headV = headView(frame: rect, refreshCount: (self?.refreshCount)!, collectionView: (self?.collectionView)!)
                        self?.view.addSubview(headV)
                        headV.show()
                    })
                }
                self?.isFirst = false
                
            })
        }
       
        collectionView.mj_header = header
        header?.beginRefreshing()
       

        //  上啦刷新
        collectionView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self ] in
            //加载更多
            NetWorkTool.loadMoreApiNewsFeeds(category: (self?.newsTitle.category)!, ttFrom: .loadMore, maxBehotTime: self!.maxBehotTime-100, listCount: self!.smallVideos.count, {
                if self!.collectionView.mj_footer.isRefreshing{
                    self!.collectionView.mj_footer.endRefreshing()
                    
                }
                self!.collectionView.mj_footer.pullingPercent = 0.0
                if $0.count == 0{
                    return
                }
                self!.smallVideos += $0
                self!.collectionView.reloadData()
                
            })
        })
        
    }
    // 刷新次数
    var isFirst:Bool = true
    var refreshCount:Int=0
    
}


//MARK: -  collectionView 数据源及代理方法
extension SmallVIdeoCategoryController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endConttentOffSet = scrollView.contentOffset.y
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallVideoCollectionViewCellID, for: indexPath) as! SmallVideoCollectionViewCell
        cell.newsModel = smallVideos[indexPath.item]
        cell.delegate = self
        cell.index = indexPath.item
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        vc.originIndex = indexPath.item
        vc.hidesBottomBarWhenPushed = true
//        vc.smallVideo = smallVideos
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - refreshDelegate 播放视频时，右滑刷新
extension SmallVIdeoCategoryController:RefreshDelegate{
    func scrollToItem(index: Int) {
        
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
        
    }
    
    func refresh( complehander:@escaping ()->()) {
        
        //加载更多
        NetWorkTool.loadMoreApiNewsFeeds(category: (self.newsTitle.category), ttFrom: .loadMore, maxBehotTime: self.maxBehotTime-100, listCount: self.smallVideos.count, {
            if self.collectionView.mj_footer.isRefreshing{
                self.collectionView.mj_footer.endRefreshing()
            }
            self.collectionView.mj_footer.pullingPercent = 0.0
            if $0.count == 0{
                return
            }
            self.smallVideos += $0
            self.collectionView.reloadData()
            
        })
        complehander()
    }
}

//MARK: - 关闭按钮代理
extension SmallVIdeoCategoryController:SmallVideoCollectionViewCellDelegate{
    
    func collectionCellRightClose(btn: UIButton, itemIndex index: Int) {
        //根据item，找到关闭按钮的切确位置
      
        let item = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
//        preIndex = index
        guard item != nil else{return}
        //btn.frame.origin = (0,0)
        let itemY = item!.frame.origin.y - endConttentOffSet
        let originY = itemY + kStatusBarH + kNavigationBarH
        let originX = item!.frame.origin.x + btn.frame.origin.x
        var frame = btn.frame
        frame.origin.y = originY
        frame.origin.x = originX
        //添加popView
        let popView = smallVIdeoPopView(frame: UIScreen.main.bounds, btnframe: frame,index:index)
        popView.collectionView = self.collectionView
        popView.smallVideos = smallVideos
        popView.delegate = self
        
        UIApplication.shared.keyWindow?.addSubview(popView)
    }
}
//MARK: - 不感兴趣点击事件代理
extension SmallVIdeoCategoryController : smallVIdeoPopViewDelegate{
    func popViewDelegate(index:Int) {
        smallVideos.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        collectionView.reloadData()
//        isDelete = true
    }
}

