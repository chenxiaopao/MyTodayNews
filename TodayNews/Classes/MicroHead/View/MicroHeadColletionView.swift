//
//  MicroHeadColletionView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
private let CollectionViewCellID = "CollectionViewCellID"

class MicroHeadColletionView: UICollectionView ,NibLoadable{
    
    var thumbImage = [ThumbImage](){
        didSet{
            reloadData()
        }
    }
  
    var largeImages = [LargeImage]()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MicroHeadColletionView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if thumbImage.count>2{
            return CGSize(width: image3Width, height: image3Width)
        }else{
            return CGSize(width: image2Width, height: image2Width)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellID, for: indexPath) as! CollectionViewCell
        cell.thumbImage = thumbImage[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let BigImageVc =  BigImageViewController()
//        BigImageVc.largeImages = self.largeImages
//        BigImageVc.selectIndex = indexPath.item
//        UIApplication.shared.keyWindow?.rootViewController?.present(BigImageVc, animated: true, completion: nil )
        
        let largeView = LargeImageCollectionView.loadViewFromNib()
        largeView.selectIndex = indexPath.item
        largeView.largeImages = self.largeImages
        largeView.thumbImages = self.thumbImage
        let cell = collectionView.cellForItem(at: indexPath)
        let frame = self.convert((cell?.frame)!, to: UIView())
        largeView.oldFrame = frame
        largeView.showBigImage()
    }
}
