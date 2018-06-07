//
//  MicroHeadViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/4.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
private let MicroHeadCellID = "MicroHeadCellID"
class MicroHeadViewController: HomeTableViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置ui
         setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //刷新
        setupRefresh(with: .weitoutiao)
        
    }
    private func setupUI(){

        tableView.register(UINib(nibName: "MicroHeadCell", bundle: nil), forCellReuseIdentifier: MicroHeadCellID)
        tableView.separatorStyle = .none
        navItem.title = "微头条"
      
        let rect = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.navItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton(frame:rect, upImageName: "follow_title_profile_18x18_", downText: "找人"))
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: UIButton(frame:rect, upImageName: "short_video_publish_icon_camera_24x24_", downText: "发布"))
//        let view = UIView()
//        view.frame = rect
//        view.backgroundColor = UIColor.red
//        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: view)
      

    }
}

extension MicroHeadViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aNews = news[indexPath.row]
        return aNews.weitoutiaoHeight
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MicroHeadCellID, for: indexPath) as! MicroHeadCell
        cell.aNews = news[indexPath.row]
        print(news[indexPath.row])
        return cell
    }
}

