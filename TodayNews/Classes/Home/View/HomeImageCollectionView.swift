//
//  HomeImageCollectionView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
private let HomeImageCellID="HomeImageCellID"

class HomeImageCollectionView: UICollectionView,NibLoadable{

    var images = [ImageList](){
        didSet{
            reloadData()
           
        }
    }
    var didSelect:((_ selectedIndex:Int)->())?
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(UINib(nibName: "HomeImageCell", bundle: nil), forCellWithReuseIdentifier: HomeImageCellID)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK:- 遵守协议
extension HomeImageCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeImageCellID, for: indexPath) as! HomeImageCell

        cell.image = images[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(indexPath.item)
    }
}
