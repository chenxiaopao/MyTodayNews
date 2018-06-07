//
//  AddChannelViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/15.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

//MARK: - 常量
private let kCloseButtonH:CGFloat = 40
private let kCloseButtonW:CGFloat = 40
private let kMarginWidth:CGFloat = 10
private let kHeaderViewH:CGFloat = 60
private let itemW:CGFloat = (kScreenW-kMarginWidth*5)/4
private let itemH:CGFloat = 40
private let MyChannelCellID = "MyChannelCellID"
private let RecommendChannellCellID = "RecommendChannellCellID"
private let MyChannelReusableViewID = "MyChannelReusableViewID"
private let RecommendChannelReusableViewID = "RecommendChannelReusableViewID"

//MARK: - AddChannelViewController
class AddChannelViewController: UIViewController {
    
    
    lazy var MyTitleArr  = [String]()
    private lazy var RecommendTitleMyTitleArr = [String]()

    private lazy var dragingItem:MyChannelCell = {

        let item = UINib(nibName: "MyChannelCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MyChannelCell
        //添加进去。。。。。。
        collectionView.addSubview(item)
        return item
    }()
   
    private var indexPath:IndexPath?
    private var targetIndexPath:IndexPath?
    private var childView:UIView!
    private var isEdit:Bool = false
    private var topLine:UIView!
    private lazy var collectionView:UICollectionView={
        //设置layout布局
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = kMarginWidth*2
        layout.minimumInteritemSpacing = kMarginWidth
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        //设置collectionView
        
        let rect = CGRect(x: 0, y: kCloseButtonH, width: kScreenW, height: kScreenH-kCloseButtonH-kStatusBarH)
        let collectionView = UICollectionView(frame:rect , collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kMarginWidth, bottom: 0, right: kMarginWidth)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MyChannelCell", bundle: nil), forCellWithReuseIdentifier: MyChannelCellID)
        collectionView.register(UINib(nibName: "RecommendChannellCell", bundle: nil), forCellWithReuseIdentifier: RecommendChannellCellID)
       
        collectionView.register( UINib(nibName: "MyChannelReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyChannelReusableViewID")
        collectionView.register( UINib(nibName: "RecommendChannelReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RecommendChannelReusableViewID)
        return collectionView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //设置UI
        setupUI()
       
        //通知
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelEditEvent), name: NSNotification.Name(rawValue: "ChannelEditEvent"), object: nil)
        //载入推荐标题数据
        print(UserDefaults.standard.bool(forKey: kSecondLaunchKey))
        if !UserDefaults.standard.bool(forKey: kSecondLaunchKey){
            NetWorkTool.loadHomeRecommendCategory {
                UserDefaults.standard.set(true, forKey: kSecondLaunchKey)
                self.RecommendTitleMyTitleArr = $0.filter({
                    $0.name != "推荐"                  
                }).flatMap({
                   $0.name
                })
            }
        }else{
          
            self.RecommendTitleMyTitleArr = UserDefaults.standard.array(forKey: kRecommendChannelTitleKey) as! [String]
           
        }
    }
}
//MARK: - 设置UI
extension AddChannelViewController{
    //设置UI
    private func setupUI(){
//       self.view.backgroundColor = UIColor.white
        //添加最外层视图
        addChildView()
        //设置关闭按钮
        addCloseBtn()
        
        //添加collectionView
        childView.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        
        //MARK: - 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent))
        longPress.minimumPressDuration = 0.5
        
        collectionView.addGestureRecognizer(longPress)
    }
    //添加最外层视图
    private func addChildView(){
        childView = UIView(frame: CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH-kStatusBarH))
        childView.backgroundColor = UIColor.white
        self.view.addSubview(childView)
        
        //添加collectionView顶部的横线
        let topLineH:CGFloat = 0.5
        
        topLine = UIView(frame: CGRect(x: 0, y: kCloseButtonH-topLineH, width: kScreenW, height: topLineH))
        topLine?.backgroundColor = UIColor.lightGray
        childView.addSubview(topLine!)
        topLine.isHidden = true
    }
    //添加关闭按钮
    private func addCloseBtn(){
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 0, y: 0, width: kCloseButtonW, height: kCloseButtonH)
        closeBtn.setImage(UIImage(named:"titlebar_close_24x24_"), for:.normal)
        closeBtn.addTarget(self, action: #selector(closeBtnEvent), for: .touchUpInside)
        childView.addSubview(closeBtn)
        
    }
    //MARK: - 关闭按钮
    @objc private func closeBtnEvent(){
       
        UserDefaults.standard.set(self.RecommendTitleMyTitleArr, forKey: kRecommendChannelTitleKey)
        UserDefaults.standard.set(MyTitleArr, forKey: kMyChannelTitleKey)
       
        dismiss(animated: true, completion: nil)
    }
    
    //编辑按钮点就
    @objc private func ChannelEditEvent(notify:Notification){
        guard let userInfo = notify.userInfo else {return }
        isEdit = userInfo["isedit"] as! Bool
        
        //关闭视图过渡动画
        UIView.performWithoutAnimation {
            //关闭CALayer的隐式动画
            CATransaction.setDisableActions(true)
            self.collectionView.reloadData()
            CATransaction.commit()
        }
    }
}

//MARK: - 遵守CollectionViewDelegate协议
extension AddChannelViewController:UICollectionViewDelegateFlowLayout{
    //collectionView滚动处理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        if contentOffset > 0{
            //滚动显示顶部的横线
            topLine.isHidden = false
        }else{
            topLine.isHidden = true
        }
    }
 
    //item点击处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            if isEdit{
                if indexPath.item == 0{
                    return
                }
                let object = MyTitleArr[indexPath.item]
                MyTitleArr.remove(at: indexPath.row)
                collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
                
                RecommendTitleMyTitleArr.insert(object, at: 0)
                collectionView.insertItems(at: [IndexPath(item: 0, section: 1)])
            }
        }else{
            let object = RecommendTitleMyTitleArr[indexPath.item]
            RecommendTitleMyTitleArr.remove(at: indexPath.row)
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 1)])
            
            MyTitleArr.insert(object, at: MyTitleArr.count)
            collectionView.insertItems(at: [IndexPath(item: MyTitleArr.count-1, section: 0)])
        }
         
    }
    
    //移动item时 处理索引路径
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        // 原索引originalIndexPath，目标索引proposedIndexPath
        if originalIndexPath.section == 1||proposedIndexPath.section==1{
            return originalIndexPath
        }
        if originalIndexPath.item == 0||proposedIndexPath.item==0{
            return originalIndexPath
        }
        return proposedIndexPath
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


//MARK: - 遵守CollectionViewDataSource协议
extension AddChannelViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = (indexPath.section == 0 ?collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MyChannelReusableViewID, for: indexPath) : collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RecommendChannelReusableViewID, for: indexPath))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChannelCellID, for: indexPath) as! MyChannelCell
      
            cell.isEdit = isEdit
            if indexPath.item == 0{
                cell.isEdit = false
            }
            cell.channelBtn.setTitle(MyTitleArr[indexPath.item], for: .normal)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendChannellCellID, for: indexPath) as! RecommendChannellCell
            cell.addBtn.setTitle(RecommendTitleMyTitleArr[indexPath.item], for: .normal)
            return cell
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return MyTitleArr.count
        }
        else{
            return RecommendTitleMyTitleArr.count
        }
    }

    //更新数据源，移动到指定位置
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let object = MyTitleArr[sourceIndexPath.item]
        MyTitleArr.remove(at: sourceIndexPath.item)
        MyTitleArr.insert(object, at: destinationIndexPath.item)
        collectionView.exchangeSubview(at: sourceIndexPath.item, withSubviewAt: destinationIndexPath.item)
    }
    
}

//MARK: - 长按拖动处理
extension AddChannelViewController{
    @objc private func longPressEvent(longPress:UILongPressGestureRecognizer){
        
        if isEdit == false{
            isEdit = true
            NotificationCenter.default.post(name: NSNotification.Name.init("longPressGestureHandle"), object: self, userInfo: ["isedit":isEdit])
            
            UIView.performWithoutAnimation {
                CATransaction.setDisableActions(true)
                self.collectionView.reloadData()
                CATransaction.commit()
            }
            
        }
        
//        //获取点击子啊collectionView的坐标
        let point:CGPoint = longPress.location(in: self.collectionView)

        switch longPress.state {
        case .began:
            dragBegan(point: point)
            break
        case .changed:
            dragChanged(point: point)
            break
        case .ended:
            dragEnd(point: point)
            break
        default:
            break
        }
       
//
//        if  longPress.state == .began{//长按开始
//            let indexPath = collectionView.indexPathForItem(at: point)
//            guard indexPath != nil else{return }
//            if indexPath?.item == 0{
//                return
//            }
//            collectionView.beginInteractiveMovementForItem(at: indexPath!)
//        }else if (longPress.state == .changed){//长按手势状态变化
//            collectionView.updateInteractiveMovementTargetPosition(point)
//        }else if longPress.state == .ended{//手势结束
//            collectionView.endInteractiveMovement()
//        }else{
//            collectionView.cancelInteractiveMovement()
//        }

    }
    //长按开始
    private func dragBegan(point:CGPoint){

        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0
        {return}
        let item = collectionView.cellForItem(at: indexPath!) as? MyChannelCell
        
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.isEdit = true
        let text = item?.channelBtn.titleLabel?.text
        dragingItem.channelBtn.setTitle(text!, for: .normal)
        

        
    }
    
    //移动过程
    private func dragChanged(point:CGPoint){
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        
        self.dragingItem.center = point
        
        targetIndexPath = collectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath || targetIndexPath?.item == 0 {return}
        // 更新数据
        let obj = MyTitleArr[indexPath!.item]
        MyTitleArr.remove(at: indexPath!.item)
        MyTitleArr.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView.moveItem(at: indexPath!, to: targetIndexPath!)
        //进行记录
        indexPath = targetIndexPath
    }
    //长按结束或取消
    private func dragEnd(point:CGPoint){
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        let endCell = collectionView.cellForItem(at: indexPath!)
        
        self.dragingItem.center = (endCell?.center)!
        
        
        endCell?.isHidden = false
        dragingItem.isHidden = true
        indexPath = nil
        
    }
}



