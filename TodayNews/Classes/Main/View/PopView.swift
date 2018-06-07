//
//  popView.swift
//  popView
//
//  Created by 陈思斌 on 2018/4/30.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
//当超过边界时，默认距离边界为10
private let kMarginWidth:CGFloat=10
private let kBottomLineH:CGFloat = 0
private let kFontSize:CGFloat = 15
///代理方法，设置按钮点击事件
protocol PopViewDelegate:class {
    func popView(_ popViewCellBtn:UIButton,popTag:Int)
}
///PopView
class PopView: UIView {
    //设置箭头离button原点的距离
    private var kDistance:CGFloat = 0
    weak var delegate : PopViewDelegate?
    var bgView:UIView!
    var point:CGPoint!
    var size:CGSize!
    var popViewSize:CGSize!
    var titleNames:[String]!
    var imageNames:[String]!
    var popTag:Int!
    /// 初始化PopView
    /// popViewSize: 定义PopView的大小
    /// arrowPoint:定义箭头的位置
    /// arrowSize:定义箭头大小，默认宽：10，高：10
    /// titleNames:标题名
    /// imageNames:图片名
    /// popTag:当一个控制器定义多个popView时需指定，在代理中区分
    init(popViewSize:CGSize,arrowPoint:CGPoint,arrowSize:CGSize=CGSize(width: 10, height: 10),titleNames:[String],imageNames:[String],popTag:Int=0) {
        super.init(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.frame = UIScreen.main.bounds
        self.popTag = popTag
        self.size = arrowSize
        self.point = arrowPoint
        self.popViewSize = popViewSize
        self.titleNames = titleNames
        self.imageNames = imageNames
        self.kDistance = popViewSize.width/4*3
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        addBgView(popViewSize, arrowPoint: point,arrowSize: size)
        addButton(self.bgView.frame, imageNames: imageNames, titleNames: titleNames)
        hidePopView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopView(tap:)))
        self.addGestureRecognizer(tap)
        

    }
    //MARK: - 初始化隐藏popView
    private func hidePopView(){
        self.isHidden = true
    }
    //MARK: - 显示popView
    func showPopView(){
        
        self.isHidden = false
    }
    //MARK: - 点击隐藏popView
    @objc private func hidePopView(tap:UITapGestureRecognizer) {
        self.isHidden = true
    }
    //MARK: - 重绘图形
    override func draw(_ rect: CGRect) {
        drowArrow(point, size: size)
    }
    //MARK: - 添加button的背景图
    private func addBgView(_ popViewSize:CGSize,arrowPoint:CGPoint,arrowSize:CGSize){
        self.bgView = UIView(frame: CGRect(origin: CGPoint(x:arrowPoint.x-kDistance,y:arrowPoint.y+arrowSize.height), size: popViewSize))

        let originX = self.bgView.frame.origin.x
        if originX < kMarginWidth{
            self.bgView.frame.origin.x = kMarginWidth
        }
        if originX+popViewSize.width+kMarginWidth > UIScreen.main.bounds.width{
            self.bgView.frame.origin.x = UIScreen.main.bounds.width-popViewSize.width-kMarginWidth
        }
        self.addSubview(bgView)

    }
    //MARK: - 画三角形
    private func drowArrow(_ point:CGPoint,size:CGSize){
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: point)
        let leftPoint = CGPoint(x: point.x-size.width, y: point.y+size.height)
        let rightPoint = CGPoint(x: point.x+size.width, y: point.y+size.height)
        context?.addLine(to: leftPoint)
        context?.addLine(to: rightPoint)
        context?.addLine(to: point)
        context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context?.fillPath()
        context?.strokePath()
        
    }
    //MARK: - 添加按钮
    private func  addButton(_ frame:CGRect,imageNames:[String],titleNames:[String]){
        //获取个数
        let count = imageNames.count<=titleNames.count ? imageNames.count : titleNames.count
        let btnSize = CGSize(width: frame.width, height: frame.height/CGFloat(count))
        
        for index in 0..<count{
            let btnY = frame.height/CGFloat(count) * CGFloat(index)
           
            let rect = CGRect(origin: CGPoint(x:0,y:btnY), size: btnSize)
            let btn = cellButton(frame: rect, titleName: titleNames[index], imageName: imageNames[index])
            btn.tag = index
            btn.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
            if (index != count-1) && (kBottomLineH>0){
                let view = UIView(frame: CGRect(x: 0, y: btnSize.height-CGFloat(kBottomLineH), width: btnSize.width, height: kBottomLineH))
                view.backgroundColor = UIColor.lightGray
                btn.addSubview(view)
            }
            self.bgView.addSubview(btn)
        }
        
    }
    
    //MARK: - 按钮点击事件
    @objc func btnClick(sender:UIButton){
        delegate?.popView(sender,popTag: self.popTag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 自定义button
class cellButton:UIButton{
    init(frame: CGRect,titleName:String,imageName:String) {
        super.init(frame: frame)
        self.setTitle(titleName, for: .normal)
        self.setImage(UIImage(named:imageName), for: .normal)
        self.contentHorizontalAlignment = .left
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.titleLabel?.font = UIFont.systemFont(ofSize: kFontSize)
        self.setTitleColor(UIColor.black, for: .normal)
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
