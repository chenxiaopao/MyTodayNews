//
//  WaterMelonTVController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import BMPlayer
private let WaterMelonTVCellID = "WaterMelonTVCellID"
class playerCustomView:BMPlayerControlView{
    override func customizeUIComponents() {
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        fullscreenButton.isEnabled = false
//        replayButton
    }

}
class WaterMelonTVController: HomeTableViewController {
    private var player:BMPlayer = {
        let playerView = playerCustomView()
        let player = BMPlayer(customControlView: playerView)
        return player
    }()
    private var realVideo = RealVideo()
    private var preCell : WaterMelonTVCell?
    /// 当前播放的时间
    private var currentTime: TimeInterval = 0
    override func viewDidLoad() {
        player.delegate = self
        tableView.register(UINib(nibName: "WaterMelonTVCell", bundle: nil), forCellReuseIdentifier: WaterMelonTVCellID)
        tableView.rowHeight = kScreenW*0.67
    }
    /// 添加播放器
    private  func addPlayer(on cell:WaterMelonTVCell){
        cell.hideSubviews()
        
        NetWorkTool.parseVideoRealURL(video_id: cell.video.video_detail_info.video_id, completionHandler: {
            self.realVideo = $0
            cell.bgButton.addSubview(self.player)
            self.player.snp.makeConstraints({ $0.edges.equalTo(cell.bgButton) })
            // 设置视频播放地址

            self.player.setVideo(resource: BMPlayerResource(url: URL(string: $0.video_list.video_1.mainURL)!, name: cell.video.title, cover: nil, subtitle: nil))
            self.preCell = cell
        })
    }
    /// 移除播放器
    private func removePlayer() {
        player.pause()
        player.removeFromSuperview()
        preCell = nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        removePlayer()
    }
    
}

extension WaterMelonTVController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for viewController in (navigationController?.viewControllers)!{
            if viewController is  WaterMelonViewController{
                if player.isPlaying{
                    let imageButton = player.superview
                    let contentView = imageButton?.superview
                    let cell = contentView?.superview as! WaterMelonTVCell
                    let rect = tableView.convert(cell.frame, from: viewController.view)
                   
                    let indexPath = tableView.indexPath(for: cell)
                    if let item = indexPath?.item{
                        let startOriginY = CGFloat(item)*cell.frame.height
                        let height = kScreenH-kStatusBarH-kNavigationBarH-40-tabBarController!.tabBar.frame.height
//                        print(startOriginY)
//                        print(height)
//                        print(scrollView.contentOffset.y)
                        if scrollView.contentOffset.y > startOriginY+cell.frame.height||startOriginY>height+scrollView.contentOffset.y{
                            removePlayer()
                            cell.showSubViews()
                        }
                    }
                    
                    
                   
                    
                    
                  
                }
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WaterMelonTVCellID, for: indexPath) as! WaterMelonTVCell
        cell.video = news[indexPath.row]
        cell.bgBtnSelector = {
            if let preCell = self.preCell{
                if preCell != cell{
                    preCell.showSubViews()
                    if self.player.isPlaying{
                        self.player.pause()
                        self.player.removeFromSuperview()
                    }
                    self.addPlayer(on: cell)
                
                }
            }else{
                self.addPlayer(on: cell)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
}
extension WaterMelonTVController:BMPlayerDelegate{
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
  
    }
    
    
}
