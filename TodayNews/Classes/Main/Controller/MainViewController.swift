//
//  MainViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.red
        addChildVc(name: "Home")
        addChildVc(name: "Watermelon")
        addChildVc(name: "MicroHead")
        addChildVc(name: "SmallVideo")
    }
    private func addChildVc(name:String){
        let childVc = UIStoryboard(name: name, bundle: Bundle.main).instantiateInitialViewController()
//        childVc?.tabBarItem.image = UIImage(named: name + "_tabbar_night_32x32_")
        addChildViewController(childVc!)
    }
}

