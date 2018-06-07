//
//  SearchViewController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

//是否设置半透明isTranslucent：false时，设置ui时不需要从44+20算起。而是从0开始
//self.navigationController?.navigationBar.isTranslucent = false


import UIKit
private let SearchRecommandReusableViewID = "SearchRecommandReusableViewID"
private let SearchHistoryReusableViewID = "SearchHistoryReusableViewID"
private let SearchCollectionViewCellID = "SearchCollectionViewCellID"
private let footerViewID = "footerViewID"
class SearchViewController: UIViewController {
    //推荐搜索数组
    var suggestArr:[String]!
    //搜索历史数组
    private lazy var searchHistory=[String]()
    var recommendCloseFlag:Bool=false
    var historyFlag:Bool=false
    private lazy var searchView:SearchBar={
        let search =  SearchBar.loadViewFromNib()
        search.cancelSelector = {
            self.navigationController?.popViewController(animated: true)
        }
        search.searchBar.delegate = self
        return search
    }()
    private lazy var collectionView:UICollectionView={
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-64)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let coll = UICollectionView(frame: rect, collectionViewLayout: layout)
        coll.showsVerticalScrollIndicator = false
        coll.dataSource = self
        //UICollectionView是默认不能滑动的，这就不能实现刷新或加载更多数据的功能了，我们需要设置一个属性：
        coll.alwaysBounceVertical = true
        coll.delegate = self
        return coll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册nib
        registerNib()
        //设置UI
        setupUI()
    }
    //注册NIB
    private func registerNib(){
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewID)
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchCollectionViewCellID)
        collectionView.register(UINib(nibName: "SearchRecommandReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchRecommandReusableViewID)
        collectionView.register(UINib(nibName: "SearchHistoryReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchHistoryReusableViewID)
    }
    //MARK: - 设置ui
    private func setupUI(){
        self.navigationItem.titleView = searchView
        self.collectionView.backgroundColor  = UIColor.white
        
        self.view.addSubview(collectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.searchHistory.count)
        self.navigationItem.hidesBackButton = true
        //是否设置半透明isTranslucent：false时，设置ui时不需要从44+20算起，即不计算导航栏和状态栏高度。而是从0开始
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        if let array  = UserDefaults.standard.array(forKey: "history"){
            self.searchHistory = array as! [String]
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(searchHistory, forKey: "history")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.perform(#selector(searchBarBecomeFirstResponder))
    }
    @objc func searchBarBecomeFirstResponder() {
        searchView.searchBar.becomeFirstResponder()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
    
}
//MARK:- 遵守collectionView代理，数据源协议
extension SearchViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    //MARK: - 多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if recommendCloseFlag{
            return 2
        }
        return 3
    }
    //MARK: - 每组section有多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recommendCloseFlag{
            if section == 0{
                return searchHistory.count
            }else{
                return 0
            }
        }
        
        if section == 0{
            return suggestArr.count
        }else if section == 1{
            return searchHistory.count
        }
        return 3
        
    }
    //MARK: - 头部／尾部视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            if recommendCloseFlag{
                if indexPath.section == 0{
                    let historyCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchHistoryReusableViewID, for: indexPath) as! SearchHistoryReusableView
                    return historyCell
                }else{
                    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchRecommandReusableViewID, for: indexPath) as! SearchRecommandReusableView
                    
                    cell.showSelector = {
                        cell.label.isHidden = false
                        cell.btnClose.isHidden = false
                        cell.btnShowRecommend.isHidden = true
                        self.recommendCloseFlag = false
                        
                        collectionView.reloadData()
                    }
                    return cell
                }
            }
            if indexPath.section == 1{
                
                let historyCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchHistoryReusableViewID, for: indexPath) as! SearchHistoryReusableView
                return historyCell
            }else if indexPath.section == 2{
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SearchRecommandReusableViewID, for: indexPath) as! SearchRecommandReusableView
                cell.closeSelector={(sender) in
                    sender.isSelected = !sender.isSelected
                    self.recommendCloseFlag = true
                    cell.label.isHidden = true
                    cell.btnClose.isHidden = true
                    cell.btnShowRecommend.isHidden = false
                    collectionView.reloadData()
                    
                }
                return cell
            }
            
        }else{
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewID, for: indexPath)
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            return cell
        }
        return UICollectionReusableView()
    }
    //MARK: - cell视图
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCellID", for: indexPath) as! SearchCollectionViewCell
        if recommendCloseFlag {
            if indexPath.section == 0{
                cell.label.text = searchHistory[indexPath.item]
            }
            return cell
        }
        if indexPath.section == 0{
            cell.label.text = suggestArr[indexPath.item]
        }else if indexPath.section == 1{
            cell.label.text = searchHistory[indexPath.item]
        }else{
            cell.label.text = "我还没获取数据"
        }
        return cell
    }
    //MARK: - 头部大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if recommendCloseFlag{
            if section == 0{
                if searchHistory.count>0{
                    return CGSize(width: kScreenW, height: 43)
                }else{
                    return CGSize.zero
                }
            }else{
                return  CGSize(width: kScreenW, height: 43)
            }
           
        }
        if section == 1{
            if searchHistory.count>0{
                return CGSize(width: kScreenW, height: 43)
            }else{
                return CGSize.zero
            }
        }else if section == 2{
            return CGSize(width: kScreenW, height: 43)
        }
        return CGSize.zero
    }
    //MARK: -  cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if recommendCloseFlag{
            if indexPath.section == 0{
                return CGSize(width: kScreenW/3, height: 40)
            }
            return CGSize.zero
        }
        if indexPath.section == 0{
            return CGSize(width: kScreenW/3, height: 43)
        }
        return CGSize(width: kScreenW/2, height: 43)
       
    }
    //MARK: - 点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "点我干么", message: "没做处理", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - 尾部大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if recommendCloseFlag{
            if section == 0{
                return CGSize(width: kScreenW, height: 8)
            }
            return CGSize.zero
        }else{
            if section == 0 || section == 1{
                return CGSize(width: kScreenW, height: 8)
            }else{
                return CGSize.zero
            }
        }
    }
    //MARK: - 滚动视图开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.searchBar.resignFirstResponder()
    }
}
//MARK: - 搜索框代理
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text?.trimmingCharacters(in: .whitespaces){
            if text != ""{
                self.searchHistory.append(text)
                self.collectionView.reloadData()
            }
        }
        searchView.searchBar.resignFirstResponder()
    }
    
}
