//
//  HomeRecommendController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
private let HomeCellID:String = "HomeCellID"
private let HomeUserCellID:String = "HomeUserCellID"
class HomeRecommendController: HomeTableViewController{
    
    override func viewDidLoad() {
        
        tableView.register(   UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: HomeCellID)
        tableView.register(   UINib(nibName: "HomeUserCell", bundle: nil), forCellReuseIdentifier: HomeUserCellID)
    }
  
}
extension HomeRecommendController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aNews = news[indexPath.row]
        switch aNews.cell_type {
            case .none:
                return aNews.cellHeight
            case .user:
                return aNews.weitoutiaoHeight
            case .relatedConcern:
                return 290
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aNews = news[indexPath.row]
        switch aNews.cell_type{
            case .none:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellID, for: indexPath) as! HomeCell
                cell.aNews = aNews
                return  cell
            case .user:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserCellID, for: indexPath) as! HomeUserCell
                cell.aNews = aNews
                return cell
            default:
               
                break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellID, for: indexPath) as! HomeCell
        cell.backgroundColor = UIColor.blue
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
}
