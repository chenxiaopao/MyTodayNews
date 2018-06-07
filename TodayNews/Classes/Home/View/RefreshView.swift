//
//  RefreshView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/29.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import MJRefresh
class RefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        
        self.lastUpdatedTimeLabel.isHidden = true
        self.lastUpdatedTimeKey = ""
        self.isAutomaticallyChangeAlpha = true
        var images = [UIImage]()

        for index in 0..<16{
            if index == 0 || index == 5 || index == 8 || index == 13{
                 let image = UIImage(named: "dropdown_loading_0\(index)")
                images.append(image!)
            }
           
            
        }
 
        //空闲状态图片
        setImages([UIImage(named:"dropdown_loading_00")], for: .idle)
        //下啦刷新的图片
        setImages([UIImage(named:"dropdown_loading_00")], for: .pulling)
        setImages(images, duration: 2, for: .refreshing)

        setTitle("下拉推荐", for: .idle)
        setTitle("松开推荐", for: .pulling)
        setTitle("推荐中", for:  .refreshing)
        mj_h = 50
        backgroundColor = UIColor.lightGray
    }
    override func placeSubviews() {
        super.placeSubviews()
        gifView.contentMode = .center
        gifView.frame = CGRect(x: 0, y: 4, width: mj_w, height: 25)
        stateLabel.font = UIFont.systemFont(ofSize: 12)
        stateLabel.frame = CGRect(x: 0, y: 35, width: mj_w, height: 14)
    }
}

class headView:UILabel{
    var refreshCount:Int = 0
    var collectionView:UICollectionView?
    var tableView:UITableView?
    init(frame: CGRect,refreshCount:Int,collectionView:UICollectionView?=nil,tableView:UITableView?=nil) {
        self.refreshCount=refreshCount
        self.collectionView = collectionView
        self.tableView = tableView
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(){
        if refreshCount==0{
            self.text = "暂无更新，休息一会儿"
        }else{
            self.text = "今日头条推荐引擎有\(refreshCount)条更新"
        }
        
        self.textAlignment = .center
        self.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        self.textColor = UIColor.blue
        if (collectionView != nil){//collectionView 在头部添加view。让y值改变就可以
            self.collectionView!.frame.origin.y+=30
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                self.collectionView!.frame.origin.y -= 30
                self.removeFromSuperview()
            })
        }else{//tableView头部添加View 设置tableHeaderView属性
            self.tableView?.tableHeaderView = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                //移除tableHeaderView
                self.tableView?.tableHeaderView?.removeFromSuperview()
                self.tableView?.tableHeaderView = nil
            })
        }
        
        
    }
}
class  RefreshAutoGifFooter:MJRefreshAutoGifFooter {
    
    /// 初始化  设置子控件
    override func prepare() {
        super.prepare()
        self.isAutomaticallyChangeAlpha = true
        // 设置控件的高度
        mj_h = 50
        // 图片数组
        var images = [UIImage]()
        // 遍历
        for index in 0..<8 {
            let image = UIImage(named: "sendloading_18x18_\(index)")
            images.append(image!)
        }
        // 设置空闲状态的图片
        setImages(images, for: .idle)
        // 设置刷新状态的图片
        setImages(images, for: .refreshing)
        setTitle("上拉加载数据", for: .idle)
        setTitle("正在努力加载", for: .pulling)
        setTitle("正在努力加载", for: .refreshing)
        setTitle("没有更多数据啦", for: .noMoreData)
    }
    override func placeSubviews() {
        super.placeSubviews()
        gifView.frame.origin.x = 135
        gifView.center.y = stateLabel.center.y
    }
    
}
