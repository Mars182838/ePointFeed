//
//  LogoutAlterView.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/13.
//  Copyright © 2016年 EB. All rights reserved.
//


typealias callbackfunc = (selectIndex:Int) -> Void

class LogoutAlterView: UIView {

    let DefaultFrame = UIScreen.mainScreen().bounds

    var contentView:UIView!
    
    var myClosure:callbackfunc?
    
    init() {

        super.init(frame:DefaultFrame)
        
        let blackView = UIView()
        blackView.frame = self.bounds
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.6
        self.addSubview(blackView)
        
        self.contentView = UIView()
        contentView.frame = CGRectMake(0, 0, 400, 200)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5.0
        self.addSubview(contentView)
        
        contentView.center = self.center
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(0, 55, contentView.width, 30)
        titleLabel.font = UIFont.systemFontOfSize(30)
        titleLabel.textColor = UIColor.brownColor()
        titleLabel.text = "确定退出该用户吗？"
        titleLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(titleLabel)
        
        let btn = UIButton.init(type: UIButtonType.Custom)
        btn.setTitle("取消", forState: UIControlState.Normal)
        btn.frame = CGRectMake((400 - 300)/3, titleLabel.height + titleLabel.originY() + 45, 150, 50)
        btn.setBackgroundImage(UIImage.init(named: "short_btn"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(LogoutAlterView.dismoveViewClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = 10
        contentView.addSubview(btn)
        
        let sureBtn = UIButton.init(type: UIButtonType.Custom)
        sureBtn.frame = CGRectMake(btn.originX() + btn.width + (400 - 300)/3, btn.originY(), 150, 50)
        sureBtn.setTitle("确定", forState: UIControlState.Normal)
        sureBtn.setBackgroundImage(UIImage.init(named: "short_btn"), forState: UIControlState.Normal)
        sureBtn.tag = 11
        sureBtn.addTarget(self, action: #selector(LogoutAlterView.dismoveViewClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(sureBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        
        let opacityAnimation = POPBasicAnimation(propertyNamed:kPOPLayerOpacity)
        opacityAnimation.fromValue = NSNumber(float:0)
        
        let scaleAnimation = POPSpringAnimation(propertyNamed:kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 20
        scaleAnimation.fromValue = NSValue(CGPoint:CGPointMake(0.1, 0.1))
        
        contentView.layer.pop_addAnimation(opacityAnimation, forKey: "opacityAnimation")
        contentView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
    
    func initWithClosure(closure:callbackfunc?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    
    func dismoveViewClick(sender:UIButton) {
        
        if (myClosure != nil) {
            
            myClosure!(selectIndex: sender.tag)

        }
        
        let scaleAnimation = POPSpringAnimation(propertyNamed:kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 10
        scaleAnimation.fromValue = NSValue(CGPoint:CGPointMake(0.6, 0.8))
        
        let offscreenAnimation = POPBasicAnimation(propertyNamed:kPOPLayerPositionY)
        offscreenAnimation.toValue = NSNumber(float:1.5*Float(self.height))
        offscreenAnimation.completionBlock = {[unowned self] (animation, finished) in
            
            self.removeFromSuperview()
        }
        contentView.layer.pop_addAnimation(offscreenAnimation, forKey: "offscreenAnimation")
        contentView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
    }
}
