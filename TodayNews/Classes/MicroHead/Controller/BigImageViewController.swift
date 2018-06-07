//
//  BigImageViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/5/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
private let LargeCollectionViewCellID = "LargeCollectionViewCell"
class BigImageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indexLabel: UILabel!
    var largeImages = [LargeImage]()
    var selectIndex:Int = 0
    private lazy var layout:UICollectionViewFlowLayout={
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing =  0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: LargeCollectionViewCellID)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        indexLabel.text =  "\(selectIndex+1)/\(largeImages.count)"
        
        
    }
    @IBAction func saveButton(_ sender: UIButton) {
        
    }
 
}

extension BigImageViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return largeImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCollectionViewCellID, for: indexPath) as! CollectionViewCell
        cell.largeImage = largeImages[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectIndex = Int(scrollView.contentOffset.x/kScreenW+0.5)
        indexLabel.text = "\(selectIndex+1)/\(largeImages.count)"
    }
}
