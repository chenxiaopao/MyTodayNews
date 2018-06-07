//
//  HomeTableViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
//    标题
    var newsTitle = HomeNewsTitle()
//    新闻数据
    var news = [NewsModel]()
//    刷新时间
    var maxBehotTime : TimeInterval = 0.0
    var timeInterval : TimeInterval = 1000
//    第一次刷新,不显示刷新个数
    var isFirst:Bool = true
//    刷新个数
    var refreshCount:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
 
    }
    func setupRefresh(with category:NewsTitleCategory = .recommend){
//         刷新头部
        let header = RefreshHeader{ [weak self] in
            //获取视频的新闻列表数据
            NetWorkTool.loadApiNewsFeeds(category: category, ttFrom: .pull, {
                if self!.tableView.mj_header.isRefreshing{
                    self!.tableView.mj_header.endRefreshing()
                }
                
                self!.maxBehotTime = $0
//                self!.news += $1
                self?.news.insert(contentsOf: $1, at: 0)
                self!.refreshCount = $1.count
                self?.tableView.reloadData()
                if !(self?.isFirst)!{
                    //先执行endRefreshing()在执行completionBlock
                    self?.tableView.mj_header.endRefreshing(completionBlock: {
                        // 显示刷新个数
                        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 30)
                        let headV = headView(frame: rect, refreshCount: (self?.refreshCount)!, tableView: (self?.tableView)!)
                        
                        headV.show()
                    })
                }
                self?.isFirst = false
                
            })
        }
        
 
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
        
//        底部刷新
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self ] in
            //加载更多
            NetWorkTool.loadMoreApiNewsFeeds(category: category, ttFrom: .loadMore, maxBehotTime: self!.maxBehotTime-(self?.timeInterval)!, listCount: self!.news.count, {
                if self!.tableView.mj_footer.isRefreshing{
                    self!.tableView.mj_footer.endRefreshing()
                }
//                print(self!.maxBehotTime-(self?.timeInterval)!)
                self?.tableView.mj_footer.pullingPercent = 0.0
                if $0.count == 0{
                    return
                }
                self?.news += $0
                self?.tableView.reloadData()
                self?.timeInterval += 1000
            })
        })
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
    }
}
