//
//  RecordController.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
import AVKit
import Photos
import AVFoundation
private let btnW:CGFloat = 80
private let btnX:CGFloat = kScreenW/2-50
private let btnY:CGFloat = kScreenH-btnW-50


class RecordController: UIViewController {

    let lineWidth:CGFloat = 10
    let downLoadEmitterLayer = CAEmitterLayer()
    var cirqueWidth:CGFloat!
    var circleWidth:CGFloat!
    var leftLine : UIView!
    var rightLine : UIView!
    var circleLayer:CAShapeLayer!
    var cirqueLayer:CAShapeLayer!
    var btn : UIButton!
    var circlePath:UIBezierPath!
    var cirquePath:UIBezierPath!
    var cirqueTranPath:UIBezierPath!
    
    //视频捕获会话 ，是input和output的桥梁 协调者input和output的数据传输
    var captureSession:AVCaptureSession!
    //视频输入设备,输入信号
    var videoDevice:AVCaptureDevice!
    var videoInput:AVCaptureDeviceInput!
    //音频输入设备，输入信号
    var audioDevice:AVCaptureDevice!
    var audioInput:AVCaptureDeviceInput!
    //将捕获的视频输出到文件
    var fileOutput:AVCaptureMovieFileOutput!
    //    最大的允许录制时间
    var totalSeconds:Float64 = 15.0
    //    剩余时间
    var remainingTime:TimeInterval = 15.0
    //    每秒帧数
    var framesPerSecond:Int32 = 30
    //    进度条视图
    var progressBar:UIView = UIView()
    //    是否停止录像
    var stopRecording:Bool = false
    //    剩余时间定时器
    var timer:Timer?
    //    进度条定时器
    var progressBarTimer:Timer?
    //    进度条定时器的时间间隔
    var incInterval:TimeInterval = 0.1
    //    当前进度条的终止位置
    var oldX:CGFloat = 0
    //    保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //    保存所有的录像片段url数组
    var assetURLs = [String]()
    //    录像片段的索引
    var appendix : Int32 = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            //设置录制按钮
            self.setupRecordBtn()
            
            //初始化音视频录制
            self.initAVRecord()
            
            
            //设置顶部进度条
            self.progressBar.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 3)
            self.progressBar.backgroundColor = UIColor.gray
            self.view.addSubview(self.progressBar)
            //创建切换按钮
            self.setupSwitchBtn()
            //创建保存按钮
            self.setupSaveBtn()
            //创建关闭按钮
            self.setupCloseBtn()
            
        }
        
    }
    //MARK: - 创建关闭按钮
    func setupCloseBtn(){
        let btn = UIButton(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        btn.setImage(UIImage(named:"ImgPic_close_24x24_"), for: .normal)
        btn.addTarget(self, action: #selector(CloseBtnClick(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    //MARK: - 关闭按钮事件
    @objc func CloseBtnClick(sender:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: - 创建保存按钮
    func setupSaveBtn(){
        
        let saveButton = UIButton(frame: CGRect(x:0,y:0,width:70,height:50))
        saveButton.backgroundColor = UIColor.gray
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("保存", for: .normal)
        saveButton.layer.cornerRadius = 20.0
        saveButton.layer.position = CGPoint(x: self.view.bounds.width - 60,
                                                 y:self.view.bounds.height-50)
        saveButton.addTarget(self, action: #selector(onClickStopButton(_:)),
                                  for: .touchUpInside)
        view.addSubview(saveButton);
    }
    
    //MARK: - 设置切换按钮
    func setupSwitchBtn(){
        let switchBtn = UIButton(frame:CGRect(x:kScreenW-100, y: 30, width: 80, height: 40))
        switchBtn.setTitle("切换", for: .normal)
        switchBtn.addTarget(self, action: #selector(switchCamera(sender:)), for: .touchUpInside)
        view.addSubview(switchBtn)
    }
    //MARK: - 切换摄像头点击事件
    @objc func switchCamera(sender:UIButton){

        let inputs:[AVCaptureDeviceInput] = captureSession.inputs as! [AVCaptureDeviceInput]
        for input in inputs{
            let device:AVCaptureDevice = input.device
            if device.hasMediaType(.video){
                let position:AVCaptureDevice.Position = device.position
                var newDevice:AVCaptureDevice!
                var newInput:AVCaptureDeviceInput!
                if  position == AVCaptureDevice.Position.front{
                    newDevice = cameraWithPosition(position: AVCaptureDevice.Position.back)
                }else{
                    newDevice = cameraWithPosition(position: AVCaptureDevice.Position.front)
                }
                newInput = try! AVCaptureDeviceInput(device: newDevice)
                
                self.captureSession.beginConfiguration()
                self.captureSession.removeInput(input)
                self.captureSession.addInput(newInput)
                self.captureSession.commitConfiguration()
                break
            }
        }
        
    }
    //
    func cameraWithPosition(position:AVCaptureDevice.Position)->AVCaptureDevice?{
       
        
        if #available(iOS 10, *){//iOS。以后
             //返回和视频录制相关的默认设备
            let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
            let devices = deviceSession.devices
            //遍历这些设备返回跟postion相关的设备
            for device in devices{
                if device.position == position{
                    return device
                }
            }
            return nil
            
        }else{
            //返回和视频录制相关的默认设备
            let devices:[AVCaptureDevice] = AVCaptureDevice.devices(for: .video)
            //遍历这些设备返回跟postion相关的设备
            for device in devices{
                if device.position == position{
                    return device
                }
            }
            return nil
        }

    }
    //MARK: - 初始化音视频录制
    func initAVRecord(){
        
        captureSession = AVCaptureSession()
        
        videoDevice = AVCaptureDevice.default(for: .video)
        audioDevice = AVCaptureDevice.default(for: .audio)
        videoInput = try! AVCaptureDeviceInput(device: videoDevice)
        audioInput = try! AVCaptureDeviceInput(device: audioDevice)
        
        //会话开始配置，可以在运行的会话中添加 移除输入，输出
        captureSession.beginConfiguration()
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        if captureSession.canAddInput(audioInput){
            captureSession.addInput(audioInput)
        }
        
        let maxDuration = CMTimeMakeWithSeconds(totalSeconds, framesPerSecond)
        fileOutput = AVCaptureMovieFileOutput()
        //设置允许录制的最长时间
        fileOutput.maxRecordedDuration = maxDuration
        
        if captureSession.canAddOutput(fileOutput){
            captureSession.addOutput(fileOutput)
        }
        captureSession.commitConfiguration()
        
        //设置预览图层
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        //预览涂层的拉伸方式，等比例拉伸，直到完全填充，一个维度部分区域会被裁减
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.insertSublayer(previewLayer, at: 0)
        //启动会话
        captureSession.startRunning()
    }
    //设置录制按钮
    func setupRecordBtn(){
        
        
        circleWidth = btnW/2-lineWidth*2
        cirqueWidth = btnW/2-lineWidth
        //设置录制按钮
        btn = UIButton()
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnW)
        btn.layer.cornerRadius = btnW/2
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        
        // 圆环动画后的path
        cirqueTranPath = UIBezierPath(point: btn.center, radius: circleWidth-lineWidth)
        //圆环 及圆的初始path
        circlePath=UIBezierPath(point:  CGPoint(x: btnW/2, y: btnW/2), radius: circleWidth)
        cirquePath = UIBezierPath(point: btn.center, radius: cirqueWidth)
        // cirqueLayer 的position属性默认为（0，0），
        //执行self.cirqueLayer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)之后，图层就跳到左上角,并不能根据中心点缩放
        //若将UIBezierPath的中心点设置为CGPoint.zero,然后指定cirqueLayer的position属性为btn.center，实现cirqueLayer的比例变换就可以实现。
        //画圆环
        
        cirqueLayer = CAShapeLayer()
        cirqueLayer.strokeColor = UIColor.white.cgColor
        cirqueLayer.fillColor = UIColor.clear.cgColor
        cirqueLayer.lineWidth = lineWidth
        cirqueLayer.path = cirquePath.cgPath
        view.layer.addSublayer(cirqueLayer)
        view.bringSubview(toFront: btn)
        
        //画中心圆
        circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.red.cgColor
        circleLayer.path = circlePath.cgPath
        btn.layer.addSublayer(circleLayer)
        
        //画暂停的两条直线
        leftLine = UIView(frame: CGRect(x: btnW/2-5, y: btnW/2-10, width: 3, height: 20))
        leftLine.backgroundColor = UIColor.white
        rightLine = UIView(frame: CGRect(x: btnW/2+5, y: btnW/2-10, width: 3, height: 20))
        rightLine.backgroundColor = UIColor.white
        
        //录制按钮添加点击事件
        btn.addTarget(self, action: #selector(recordBtnClick(sender:)), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPress:)))
        longPress.minimumPressDuration = 0.5
        btn.addGestureRecognizer(longPress)
        
        
    }

    //MARK: - 录制按钮长按处理
    @objc func longPress(longPress:UILongPressGestureRecognizer){
        switch longPress.state {
        case .began:
            //开始录制
            beginRecord()
            //启动录制动画
            recordAnimate()
        case .ended,.cancelled:
            //重置圆环
            resetCirqueLayer()
            //停止录制
            stopRecord()
        default:
            break
        }
        
    }
    //MARK: - 重置圆环
    func resetCirqueLayer(){
        self.cirqueLayer.removeAllAnimations()
        self.cirqueLayer.opacity = 1
        self.cirqueLayer.fillColor = UIColor.clear.cgColor
    }

    
    //MARK: - 录制按钮长按动画
    
    func recordAnimate(){
        let basic = CABasicAnimation(keyPath: "path")
        basic.fromValue  = self.cirquePath.cgPath
        basic.toValue = self.cirqueTranPath.cgPath
        basic.duration = 0.3
        self.cirqueLayer.add(basic, forKey: "cirqueTranPath")
        
        
        
        let cirquePath = UIBezierPath(point: self.btn.center, radius: btnW/2+10)
        let basic1 = CABasicAnimation(keyPath: "path")
        basic1.fromValue = self.cirqueTranPath.cgPath
        basic1.toValue = cirquePath.cgPath
        basic1.duration = 0.3
        basic1.beginTime = CACurrentMediaTime()+0.3
        self.cirqueLayer.fillColor = UIColor.white.cgColor
        self.cirqueLayer.opacity = 0.2
        self.cirqueLayer.add(basic1, forKey: "cirqueTranPath1")
        
        
        let middleCirclePath = UIBezierPath(point: self.btn.center, radius: btnW/2-10)
        let basic2 = CABasicAnimation(keyPath: "path")
        basic2.beginTime = CACurrentMediaTime()+0.6
        basic2.duration = 0.5
        basic2.fromValue = cirquePath.cgPath
        basic2.toValue = middleCirclePath.cgPath
        basic2.autoreverses  = true
        basic2.repeatCount = MAXFLOAT
        
        
        let basic21 = CABasicAnimation(keyPath: "opacity")
        basic21.fromValue = 0.1
        basic21.toValue = 0.7
        basic21.duration = 0.5
        basic21.autoreverses = true
        basic21.repeatCount = MAXFLOAT
        basic21.beginTime = CACurrentMediaTime()+0.6
        self.cirqueLayer.add(basic21, forKey: "cirqueTranPath21")
        self.cirqueLayer.add(basic2, forKey: "cirqueTranPath2")
    }
   
    //MARK: - 录制按钮点击事件及动画
    @objc func recordBtnClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            //开始录制
            beginRecord()
            UIView.animate(withDuration: 0.3, animations: {
                let basic = CABasicAnimation(keyPath: "path")
                basic.toValue = self.cirqueTranPath.cgPath
                basic.isRemovedOnCompletion = false
                basic.fillMode = kCAFillModeForwards
                self.cirqueLayer.add(basic, forKey: "cirqueTranPath")
                
                self.leftLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.rightLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.btn.addSubview(self.leftLine)
                self.btn.addSubview(self.rightLine)
                self.leftLine.alpha = 1
                self.rightLine.alpha = 1
            }, completion: { (true) in })
        }else{
            //停止录制
            stopRecord()
            UIView.animate(withDuration: 0.3, animations: {
                
                let basic = CABasicAnimation(keyPath: "path")
                basic.toValue = self.cirquePath.cgPath
                basic.isRemovedOnCompletion = false
                basic.fillMode = kCAFillModeForwards
                self.cirqueLayer.add(basic, forKey: "cirqueTranPath1")
                
                self.leftLine.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.leftLine.alpha = 0.1
                self.rightLine.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.rightLine.alpha = 0.1
            }, completion: { (true) in
                self.leftLine.removeFromSuperview()
                self.rightLine.removeFromSuperview()
                self.cirqueLayer.removeAllAnimations()
            })
            
        }
        
    }

    
}
//MARK: - ------------ 视频输出代理----------
extension  RecordController:AVCaptureFileOutputRecordingDelegate{
    //MARK: - 录像开始代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        startTimer()
        startProgressBarTimer()
    }
    //MARK: - 录像结束代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        var duration : TimeInterval = 0.0
        duration = CMTimeGetSeconds(asset.duration)
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        
        remainingTime -= duration
        
        if remainingTime <= 0{
            mergeVideo()
        }
    }
    //MARK: - 合并视频片段
    func mergeVideo(){
        let duration = totalSeconds
        let composition = AVMutableComposition()
        // 合并视频 音频轨道
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID())
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID())
        
        var insertTime:CMTime = kCMTimeZero
        
        for asset in videoAssets{
            if asset.duration != kCMTimeZero{
                do{
                    
                    try videoTrack?.insertTimeRange( CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: asset.tracks(withMediaType: .video)[0], at: insertTime)
                }catch{}
                
                do{
                    try audioTrack?.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: asset.tracks(withMediaType: .audio)[0], at: insertTime)
                }catch{}
                insertTime = CMTimeAdd(insertTime, asset.duration)
            }
        }
        
        //旋转视频图像，防止90度颠倒
        videoTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mov"
        
        let videoPath = URL(fileURLWithPath: destinationPath)
        
        //AVAssetExportSession 用于配制渲染参数并渲染
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, framesPerSecond))
        exporter.exportAsynchronously(completionHandler: {
            //将合并后的视频保存到相册
            self.exportDidFinish(session: exporter)
        })
    }
    //MARK: - 将合并后的视频保存到相册
    func exportDidFinish(session:AVAssetExportSession){
        let outputURL = session.outputURL!
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }) { (isSuccess, error) in
            if isSuccess{
                DispatchQueue.main.async {
                    //重置参数
                    self.reset()
                    
                    //弹出提示框
                    let alertController = UIAlertController(title: "视频保存成功",
                                                            message: "是否需要回看录像？",
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                        action in
                        //录像回看
                        self.reviewRecord(outputURL: outputURL)
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel,
                                                     handler: nil)
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true,
                                 completion: nil)
                }
            }
            
        }
    }
    
    //MARK: - 重制参数
    func reset(){
        // s删除视频片段
        for assetUrl in assetURLs{
            if (FileManager.default.fileExists(atPath: assetUrl)){
                do{
                    try FileManager.default.removeItem(atPath: assetUrl)
                }catch{}
                
            }
        }
        //        进度条还原
        for view in progressBar.subviews{
            view.removeFromSuperview()
        }
        
        //        参数还原
        videoAssets.removeAll(keepingCapacity: false)
        assetURLs.removeAll(keepingCapacity: false)
        appendix = 1
        oldX = 0
        stopRecording = false
        remainingTime = totalSeconds
    }
    //MARK: - 剩余时间定时器
    func startTimer(){
        timer = Timer(timeInterval: remainingTime, target: self, selector: #selector(timeOut), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    //MARK: - 录制时间到达最大时间
    @objc func timeOut(){
        stopRecording = true
        fileOutput.stopRecording()
        timer?.invalidate()
        progressBarTimer?.invalidate()
    }
    //MARK: - 进度条计时器
    func startProgressBarTimer(){
        progressBarTimer = Timer(timeInterval: incInterval, target: self, selector: #selector(progress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressBarTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    //MARK: - 进度条处理
    @objc func progress(){
        let progressProportion:CGFloat = CGFloat(incInterval/totalSeconds)
        let progressInc = UIView()
        progressInc.backgroundColor = UIColor.red
        
        let newWidth = progressBar.frame.width * progressProportion
        progressInc.frame = CGRect(x: oldX, y: 0, width: newWidth, height: progressBar.frame.height)
        oldX += newWidth
        progressBar.addSubview(progressInc)
    }
    //MARK: - 预览录制
    func reviewRecord(outputURL:URL){
        let player = AVPlayer(url:outputURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true, completion: nil)
    }
    
    //MARK: - 保存按钮
    @objc func onClickStopButton(_ sender:UIButton){
        mergeVideo()
    }
    //MARK: - 开始视频录制
    func beginRecord(){
        if (!stopRecording){
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let outputFilePath = "\(documentsDirectory)/output-\(appendix).mov"
            
            appendix += 1
            let outputURL = URL(fileURLWithPath: outputFilePath)
            
            if FileManager.default.fileExists(atPath: outputFilePath){
                do{
                    try  FileManager.default.removeItem(atPath: outputFilePath)
                }catch{
                    
                }
            }
            fileOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    }
    //MARK: - 停止视频录制
    func stopRecord(){
        timer?.invalidate()
        progressBarTimer?.invalidate()
        fileOutput.stopRecording()
    }
}
