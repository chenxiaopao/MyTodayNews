//
//  BMplayerCustomView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import BMPlayer

class BMplayerCustomView:BMPlayerControlView{
    override func customizeUIComponents() {
        replayButton.removeFromSuperview()
        BMPlayerConf.topBarShowInCase = .none
        playButton.removeFromSuperview()
        currentTimeLabel.removeFromSuperview()
        totalTimeLabel.removeFromSuperview()
        timeSlider.removeFromSuperview()
        fullscreenButton.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}
