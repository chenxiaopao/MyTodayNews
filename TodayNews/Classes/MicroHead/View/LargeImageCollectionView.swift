//
//  LargeImageCollectionView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Photos
private let BigCollectionViewCellID1 = "BigCollectionViewCellID1"
class LargeImageCollectionView: UIView,NibLoadable {
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var selectLabel: UILabel!
    
    var largeImages = [LargeImage]()
    var thumbImages = [ThumbImage]()
    var selectIndex:Int = 0
    var oldFrame:CGRect!
    private lazy var layout:UICollectionViewFlowLayout={
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenW, height: kScreenH-100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    @IBAction func savaButton(_ sender: UIButton) {

        ImageDownloader.default.downloadImage(with: URL(string: largeImages[selectIndex].urlString)!, progressBlock: { (receivedSize, totalSize) in
            let progress = Float(receivedSize/totalSize)
            SVProgressHUD.showProgress(progress)

        }) { (image, error, url, data) in
            if (error != nil){

                ImageDownloader.default.downloadImage(with: URL(string: self.thumbImages[self.selectIndex].urlString)!, progressBlock: { (receivedSize, totalSize) in
                    let progress = Float(receivedSize/totalSize)
                    SVProgressHUD.showProgress(progress)
                    
                }){ (image, error, url, data) in
                    if let image = image{
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                        }, completionHandler: { (isSuccess, error) in
                            SVProgressHUD.dismiss()
                            if isSuccess{
                                SVProgressHUD.showSuccess(withStatus: "保存成功")
                            }
                        })
                    }
                }
            }
            if let image = image{
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (isSuccess, error) in
                    SVProgressHUD.dismiss()
                    if isSuccess{
                        SVProgressHUD.showSuccess(withStatus: "保存成功")
                    }
                })
            }
           
        }
        
//        UIImageWriteToSavedPhotosAlbum 需指定image
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
//
        
    }
//    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
//        if error != nil{
//            SVProgressHUD.showSuccess(withStatus: "保存成功")
//        }
//    }
    override func awakeFromNib() {


        self.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        self.backgroundColor = UIColor.black
        collectionVIew.alpha = 0
        collectionVIew.collectionViewLayout = layout
        collectionVIew.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: BigCollectionViewCellID1)
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.isPagingEnabled = true
        collectionVIew.backgroundColor = UIColor.black
    

    }
    override func layoutSubviews() {
        
        collectionVIew.scrollToItem(at:IndexPath(item: selectIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        selectLabel.text = "\(selectIndex+1)/\(largeImages.count)"
   
    }

    func showBigImage(){
        collectionVIew.frame = oldFrame
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-100)
        UIView.animate(withDuration: 0.3) {
            self.collectionVIew.alpha = 1
            self.collectionVIew.frame = rect
        }
    }
 
}
extension LargeImageCollectionView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  largeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVIew.dequeueReusableCell(withReuseIdentifier: BigCollectionViewCellID1, for: indexPath) as! CollectionViewCell

        cell.largeImage = largeImages[indexPath.item]
        cell.thumb = thumbImages[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.collectionVIew.frame = self.oldFrame
        }) { (true) in
            self.removeFromSuperview()
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectIndex = Int(scrollView.contentOffset.x / kScreenW + 0.5)
        selectLabel.text = "\(selectIndex+1)/\(largeImages.count)"
        
    }
    
}
