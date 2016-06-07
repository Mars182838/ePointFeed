//
//  CustomAlterView.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/10.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

enum statusType {
    case success
    case error
}

protocol CustomAlterProtocol{
    
    func changeTextTitle(value title:String, detail:String, isInqiury:Bool)
}

typealias dismissBlock = (type:statusType) -> Void

class CustomAlterView: UIView {

    var titleLabel:UILabel!
    
    var detailLabel:UILabel!
    
    let DefaultFrame = UIScreen.mainScreen().bounds

    var stringImage:String!
    
    var btnTitle:String!
    
    var btn:UIButton!
    
    var btnImage:UIImage!
    
    var imageView:UIImageView!
    
    var myClosure:dismissBlock?
    
    init(stype:statusType) {
        
        super.init(frame: DefaultFrame)
        
        self.stringImage = (stype == statusType.success ? "successImg.png":"errorImg.png")

        self.btnTitle = (stype == statusType.success ? "完成":"返回")
        
        let blackView = UIView()
        blackView.frame = DefaultFrame
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.6
        self.addSubview(blackView)
        
        let image = UIImage.init(named: self.stringImage)
        imageView = UIImageView(frame:CGRectMake(0, 0, (image?.size.width)!, image!.size.height))
        imageView.image = image
        self.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(0, 165, imageView.frame.size.width, 30)
        titleLabel.font = UIFont.systemFontOfSize(24)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        imageView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, imageView.frame.size.width, 30)
        detailLabel.textColor = UIColor.whiteColor()
        detailLabel.font = UIFont.systemFontOfSize(14)
        detailLabel.textAlignment = NSTextAlignment.Center
        imageView.addSubview(detailLabel)
        imageView.center = self.center
        imageView.userInteractionEnabled = true
        
        btnImage = UIImage.init(named: "login_blue_btn")
        
        btn = UIButton.init(type: UIButtonType.Custom)
        btn.setTitle(self.btnTitle, forState: UIControlState.Normal)
        btn.setBackgroundImage(btnImage, forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(CustomAlterView.dismoveViewClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(btn)
       
        self.updateUI(stype)

    }
    
    func updateUI(stype:statusType) {
        
        if stype == statusType.success {
            
            btn.frame = CGRectMake((imageView.frame.size.width-(btnImage?.size.width)!)/2, detailLabel.frame.size.height + detailLabel.frame.origin.y + 55, (btnImage?.size.width)!, (btnImage?.size.height)!)
        }
        else{
        
            titleLabel.frame = CGRectMake(0, 40, imageView.frame.size.width, 30)
            detailLabel.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, imageView.frame.size.width, 30)
            btn.frame = CGRectMake((imageView.frame.size.width-(btnImage?.size.width)!)/2, detailLabel.frame.size.height + detailLabel.frame.origin.y + 50, (btnImage?.size.width)!, (btnImage?.size.height)!)
        }
    }
    
    func changeTextTitle(value title:String, detail:String, isInqiury:Bool){
        
        titleLabel.text = title
        detailLabel.text = detail
        
        if isInqiury {
            
            detailLabel.font = UIFont.systemFontOfSize(24)
            titleLabel.font = UIFont.systemFontOfSize(14)
        }
    }
    
    func show(){
       
        let opacityAnimation = POPBasicAnimation(propertyNamed:kPOPLayerOpacity)
        opacityAnimation.fromValue = NSNumber(float:0)
        
        let scaleAnimation = POPSpringAnimation(propertyNamed:kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 20
        scaleAnimation.fromValue = NSValue(CGPoint:CGPointMake(0.1, 0.1))
        
        imageView.layer.pop_addAnimation(opacityAnimation, forKey: "opacityAnimation")
        imageView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
    
    func dismissClosure(closure:dismissBlock?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    
    func dismoveViewClick(sender:UIButton) {
        
        if (myClosure != nil) {

            myClosure!(type: statusType.success)
        }
        
        let scaleAnimation = POPSpringAnimation(propertyNamed:kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 10
        scaleAnimation.fromValue = NSValue(CGPoint:CGPointMake(0.6, 0.8))
        
        let offscreenAnimation = POPBasicAnimation(propertyNamed:kPOPLayerPositionY)
        offscreenAnimation.toValue = NSNumber(float:1.5*Float(self.height))
        offscreenAnimation.completionBlock = {[unowned self] (animation, finished) in
            
            self.removeFromSuperview()
        }
        imageView.layer.pop_addAnimation(offscreenAnimation, forKey: "offscreenAnimation")
        imageView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }

}
