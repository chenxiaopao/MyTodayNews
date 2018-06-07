//
//  PageTitleView.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/14.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit

@objc protocol PageTitleViewDelegate : class{
    @objc optional func pageTitleViewSetRightBtnVC()
    func pageTitleView(currentTapIndex:Int)
}
//将颜色定义为元组
private let kNormalColor:(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor:(CGFloat,CGFloat,CGFloat) = (255,128,0)

//private let kLabelMarginWidth:CGFloat = 20
private let kFontSize:CGFloat = 20
private let kRightButtonW:CGFloat = 40
private let kTitleViewW:CGFloat = kScreenW - kRightButtonW

struct PageTitleViewConfigure {
    var kLabelMarginWidth:CGFloat
    var kIsScroll:Bool
    var kIsDefaultFisrtIndex:Bool
    ///默认值：kLabelMarginWidth:20,
    ///kIsScroll:可以点击而且跟随滚动，
   ///kIsDefaultFisrtIndex：默认是为0的索引位置
    init(kLabelMarginWidth:CGFloat=20,kIsScroll:Bool=true,kIsDefaultFisrtIndex:Bool=false) {
        self.kLabelMarginWidth = kLabelMarginWidth
        self.kIsScroll = kIsScroll
        self.kIsDefaultFisrtIndex = kIsDefaultFisrtIndex
    }
    
}

class PageTitleView:UIView{
    
    
    
    var config = PageTitleViewConfigure()
    //MARK: - 定义属性
    private var imageName:String = ""
    weak var delegate:PageTitleViewDelegate?
    var titles:[String]!
    private var scrollViewContentSize:CGFloat = 0
    private var allLabelWidth:CGFloat = 0
    private var currentTapIndex:Int=0
    //MARK: - 懒加载属性
    private lazy var allLabels:[UILabel]=[UILabel]()
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    
    //构造函数
    init(frame: CGRect,titles:[String],imageName:String,config:PageTitleViewConfigure) {
        
        self.imageName = imageName
        self.config = config
        self.titles = titles
        super.init(frame: frame)
      
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 设置UI
extension PageTitleView{
     func setupUI(){
        //添加scrollView
        addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: kTitleViewW, height: frame.height)
      
        //设置label
        setupLabel()
      
        //设置右边频道按钮
        if imageName != ""{
            setupRightChannelButton()
        }else{
            scrollView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: frame.height)
        }
        
        scrollView.contentSize = CGSize(width: scrollViewContentSize, height: self.bounds.height)
        
        // 添加titleView的底线
        addBottomLine()
    }
    
    //设置label
    private func setupLabel(){
        
        var preLabelX :CGFloat = 0
        var titleWidth:CGFloat = 0
    
        for (index,title) in titles.enumerated(){
            //当前label的X坐标
            let labelX = config.kLabelMarginWidth +  preLabelX + titleWidth
            //获取标题字符串宽度
            titleWidth = title.calculateWidthWithString(font: UIFont.systemFont(ofSize: kFontSize))
            //创建label
            let label = UILabel()
            label.frame = CGRect(x: labelX, y: 0, width: titleWidth, height: self.frame.height)
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: kFontSize)
            label.adjustsFontSizeToFitWidth = true
            if config.kIsDefaultFisrtIndex{
                if label.tag == 1{
                    label.textColor = UIColor.orange
                }else{
                    label.textColor = UIColor.darkGray
                }
            }else{
                if label.tag == 0{
                    label.textColor = UIColor.orange
                }else{
                    label.textColor = UIColor.darkGray
                }
            }
          
            scrollView.addSubview(label)
            allLabels.append(label)
            
            //label添加点击事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapEvent(sender:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
            //获取前一个lable的x坐标
            preLabelX = labelX
            //获取所有标题字符串的宽度
            allLabelWidth += titleWidth
        }
        //titleView的总宽度=标题宽度+外边距宽度
        scrollViewContentSize = allLabelWidth+CGFloat(titles.count+1)*config.kLabelMarginWidth
    
    }
    //设置右边频道按钮
    private func setupRightChannelButton(){

        let btn = UIButton(frame: CGRect(x: self.frame.width-kRightButtonW, y: 0, width: kRightButtonW, height: self.frame.height))
        btn.setImage(UIImage(named:self.imageName), for: .normal)
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        
        addSubview(btn)
    }
    // 添加titleView的底线
    private func addBottomLine(){
        let bottomLineH : CGFloat = 0.3
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height-bottomLineH, width: kScreenW, height: bottomLineH)
        bottomLine.backgroundColor = UIColor.lightGray
        addSubview(bottomLine)
    }
}


//MARK: - 处理点击事件
extension PageTitleView{
    //MARK: - label点击事件
    @objc private func labelTapEvent(sender:UITapGestureRecognizer){
        //1.label颜色变化
        //设置当前label的颜色
        let currentLabel = sender.view as! UILabel
        
        //点击原来的label。则返回
        if currentTapIndex ==  currentLabel.tag{
            return
            
        }
        currentLabel.textColor = UIColor.orange
    
        //设置之前label的颜色
        let oldLabel = allLabels[currentTapIndex]
        oldLabel.textColor = UIColor.darkGray
        
        //更新index
        currentTapIndex = currentLabel.tag
        
        if config.kIsScroll{
            scrollLabel(currentLabel)
        }
    
        
        delegate?.pageTitleView(currentTapIndex: currentTapIndex)
    }
    //label滚动到指定位置
    func scrollLabel(_ currentLabel:UILabel){
        //2.处理label的滚动
        //计算当前label的中点位置
        let labelCenterX = currentLabel.frame.origin.x + currentLabel.frame.width/2
        //条件1:如果当前label的中点大于titleView宽度的一半时
        //条件2:如果当前label的中点加上titleView宽度的一半小于scrollView的contentsize时，
        //都需要滚动到中点
        if labelCenterX >= kTitleViewW/2 && labelCenterX+kTitleViewW/2 <= scrollView.contentSize.width {
    
            //kTitleViewW/2 表示滚动视图的中点，相对于frame
            //labelCenterX表示label的中点,相对于contentSize
            //center=labelCenterX - kTitleViewW/2，表示偏移量的值
            //默认情况下，contentOffset为0，要滚动到中点位置，先固定到滚动视图的中点：kTitleViewW/2， center的值就是偏移量
           
            let offsetX = labelCenterX - kTitleViewW/2
           
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x=offsetX
            })
        }else if labelCenterX < kTitleViewW/2{//滚动到起点
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x = 0
            })
        }else{//滚动到终点
            let offsetX = self.scrollView.contentSize.width - kTitleViewW
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x = offsetX
            })
        }
      

    }
    
    //MARK: - 右边频道按钮点击事件
    @objc private func btnClickAction(){
        delegate?.pageTitleViewSetRightBtnVC!()
    }
    
}

//MARK: - 添加暴露方法
extension PageTitleView{
    func getProgressAndIndex(progress:CGFloat,currentIndex:Int,targetIndex:Int){

        
        let currentLabel = allLabels[targetIndex]
        let oldLabel = allLabels[currentIndex]
        let deltaColor = (kSelectColor.0-kNormalColor.0,kSelectColor.1-kNormalColor.1,kSelectColor.2-kNormalColor.2)
        
        currentLabel.textColor = UIColor(red: (kNormalColor.0+deltaColor.0 * progress)/255.0, green:(kNormalColor.1+deltaColor.1 * progress)/255.0 , blue: (kNormalColor.2+deltaColor.2 * progress)/255.0, alpha: 1.0)

        oldLabel.textColor = UIColor(red: (kSelectColor.0-deltaColor.0 * progress)/255.0, green:(kSelectColor.1-deltaColor.1 * progress)/255.0 , blue: (kSelectColor.2-deltaColor.2 * progress)/255.0, alpha: 1.0)
        
        //pageContentView 滑动时，scrollView滚动到指定位置
        if config.kIsScroll{
            scrollLabel(currentLabel)
        }
        // 同步index
        currentTapIndex = targetIndex
    }
}
