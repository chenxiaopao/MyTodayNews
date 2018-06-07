//
//  VideoPlayerController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/6.
//  Copyright © 2018年 陈思斌. All rights reserved.


//全局pop手势
//        guard  let targets = navigationController?.interactivePopGestureRecognizer?.value(forKey: "_targets") as?[AnyObject] else {
//            return
//        }
//
//        let dict = targets[0]
//        //拿到action
//        let target = dict.value(forKey: "target") as Any
//        //通过字典无法拿到action，这里通过Selector方法包装action
//        let action = Selector(("handleNavigationTransition:"))
//
//        //拿到target action 创建pan手势并添加到全屏view上
//        gesture = UIPanGestureRecognizer(target: target, action: action)

import UIKit
import BMPlayer
import Alamofire
private let videoPlayerCellID = "videoPlayerCellID"
private let  firstLineDic:[String:String]=["weixinicon_login_profile_66x66_":"微信","sinaicon_login_profile_66x66_":"微博"]
private let  secondLineDic:[String:String]=["weixinicon_login_profile_66x66_":"微信","sinaicon_login_profile_66x66_":"微博","qqicon_login_profile_66x66_":"QQ"]
//MARK:- delegate 播放视频时，右滑刷新
protocol RefreshDelegate{
    func refresh( complehander: @escaping()->())
    func scrollToItem(index:Int)
}
//MARK: - VideoPlayerController
class VideoPlayerController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var gesture = UIPanGestureRecognizer()

    var  smallVideo = [NewsModel]()
    var originIndex:Int  = 0
    var  delegate:RefreshDelegate?
    //判断是否是第一个播放器，true时左滑推出
    var isFirstPlayer:Bool = true
    //每次点击item的偏移量
    var currentContentOffset:CGFloat = 0
    var doubleTap:UITapGestureRecognizer!
    private lazy var collectionView:UICollectionView={
        
        let layout  = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: kScreenW, height: kScreenH)
        let collectionVIew = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.isPagingEnabled = true
        
        return collectionVIew
    }()
    //    设置播放器
    private lazy var player :BMPlayer = {
        let play = BMPlayer(customControlView:BMplayerCustomView())
        play.delegate = self
        return play
    }()
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapEvent(tap:)))
        doubleTap.numberOfTapsRequired = 2
        self.collectionView.addGestureRecognizer(doubleTap)
        self.view.addSubview(collectionView)

        collectionView.register(UINib(nibName: "videoPlayerCell", bundle: nil), forCellWithReuseIdentifier: videoPlayerCellID)
        collectionView.backgroundColor = UIColor.clear
        //添加粒子图层
        emitterLayer = CAEmitterLayer()
        self.collectionView.layer.addSublayer(emitterLayer)


    }
    
    override func viewDidAppear(_ animated: Bool) {

        //设置播放器
        setupPlayer(currentIndex:originIndex)
        //让collectionView滚动到指定的item
        collectionView.scrollToItem(at: IndexPath(item: originIndex, section: 0), at: .centeredHorizontally, animated: false)
        currentContentOffset = CGFloat(originIndex) * kScreenW
        
    }
    //MARK: - closeBtn
    @objc func closeBtn(sender:Notification){
        self.player.pause()
        self.navigationController?.popViewController(animated: true)
        
    }

    private var emitterLayer:CAEmitterLayer!
    //MARK: - 双击例子效果
    @objc func doubleTapEvent(tap:UITapGestureRecognizer){

//设置frame之后position会变化，所以不要设置frame
//        emitterLayer.frame = self.collectionView.frame
//        emitterLayer.position = CGPoint(x: point.x+207, y: point.y+368)
//print(emitterLayer.position)207,368
        
        emitterLayer.emitterShape = kCAEmitterLayerPoint
        emitterLayer.emitterMode  = kCAEmitterLayerSurface
   
        let point = tap.location(in: self.collectionView)

        emitterLayer.position = CGPoint(x: point.x, y: point.y)

        emitterLayer.birthRate = 1

        var emitterCells = [CAEmitterCell]()
        for i in 0..<10{
            let emitterCell = CAEmitterCell()
            emitterCell.contents = UIImage(named:"emoji_\(i)_32x32_")?.cgImage
            emitterCell.emissionLongitude = CGFloat(36*(i+1))
            emitterCell.velocity = 450
            emitterCell.velocityRange = 100
            emitterCell.birthRate = 1
            emitterCell.lifetime = 0.3
            emitterCell.scale = 0.3
            emitterCells.append(emitterCell)
        }
        emitterLayer.emitterCells = emitterCells
        self.perform(#selector(self.stop), with: nil, afterDelay:0.5)
       
    }
    @objc func stop(){
        emitterLayer.birthRate = 0
    
    }

    
    //MARK: - 设置播放器
    func setupPlayer(currentIndex:Int){
         NotificationCenter.default.addObserver(self, selector: #selector(closeBtn(sender:)), name: NSNotification.Name(rawValue: "SmallVideoCloseBtn"), object: nil)
//        获取指定索引的数据
        let videoModel = smallVideo[currentIndex]
        if let videoURLString = videoModel.raw_data.video.play_addr.url_list.first{
            
            DispatchQueue.main.async {
                
                let cell = self.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? videoPlayerCell
                if self.player.isPlaying{
                    self.player.pause()
                }
                
                guard cell != nil else{return}
                for view in ((cell?.iamgeView.subviews))!{
                    view.removeFromSuperview()
                }
                cell?.iamgeView.addSubview(self.player)
                self.player.frame = ((cell?.iamgeView.bounds))!
                self.asset = BMPlayerResource(url: URL(string: (videoURLString))!)
                self.player.setVideo(resource: self.asset)
                
            }

        }
    }
    var asset : BMPlayerResource!
    // MARK: UICollectionView数据源和代理
    //滑动之前的偏移
    var startcontentOffX : CGFloat = 0
//    刷新之后的个数
    var refreshAfterC = 0
//    刷新之前的个数
    var refreshBeforeC = 0
//    判断是否可以刷新
    var canRefresh = false
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startcontentOffX = scrollView.contentOffset.x
    }
    //MARK: - scrollView 开始减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffX = scrollView.contentOffset.x
     

        //获取滑动之前索引
        let oIndex = Int(startcontentOffX / scrollView.frame.width)
        //获取当前索引
        let currentIndex =  Int(contentOffX / scrollView.frame.width + 0.5)
        
        //可以刷新，重新加载collectionView
        if canRefresh{
            self.collectionView.reloadData()
        }
        //重置刷新
        canRefresh = false

        //倒数第二个开始刷新
        if currentIndex == smallVideo.count-2{
            // 开始刷新
            delegate?.refresh {}
            canRefresh = true
            
        }
        

        // 根据当前索引设置播放器
        if currentIndex != oIndex {
            setupPlayer(currentIndex: currentIndex)
            delegate?.scrollToItem(index: currentIndex)
        }
        
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return smallVideo.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoPlayerCellID, for: indexPath) as! videoPlayerCell
        
        cell.smallVideo = smallVideo[indexPath.item]
        cell.shareSelector = {
            let shareView = ShareView(firstLineDic: firstLineDic, secondLineDic: secondLineDic)
            shareView.delegate = self
            shareView.showShareView()
            
        }
        return cell
    }
    
}
//MARK: - shareViewDelegate
extension VideoPlayerController:shareViewDelegate{
    func shareViewFirst(_ firstScrollViewButton: UIButton) {
        alert(str: "第一个ScrollView的第\(firstScrollViewButton.tag)个按钮")
    }
    private func alert(str:String){
        let alert = UIAlertController(title: "点击的是\(str)", message: "未做处理", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    func shareViewSecond(_ secondScrollViewButton: UIButton) {
        alert(str: "第二个ScrollView的第\(secondScrollViewButton.tag)个按钮")
    }

}
//MARK: - BMPlayerDelegate
extension VideoPlayerController:BMPlayerDelegate{
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        switch state {
        case .playedToTheEnd:
            self.player.setVideo(resource: self.asset)
            
        default:
            break
        }
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
}

