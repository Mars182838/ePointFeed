//
//  FirstViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/9.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var rechargeVC: RechargingViewController!
    
    var inquiry :InquiryViewController!
    
    var exchange :ExchangeViewController!

    var myAccountVC : MyAccountViewController!
    
    var imageScrollView: SDCycleScrollView!
    
    var timer:NSTimer!
    
    var carArray:NSArray!
    
    var imageArrays:NSMutableArray!
    
    
    //定义屏幕宽度
    let kScreenWidth = UIScreen.mainScreen().bounds.size.width
    //定义屏幕高度
    let kScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    @IBOutlet var transitionButtons: [UIButton]!
    
    @IBAction func transitionButtonClick(sender: AnyObject) {
    
        for transitionBtn in transitionButtons {
            
            transitionBtn.setTitleColor(UIColor.init(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1), forState: UIControlState.Normal)
            transitionBtn.backgroundColor = UIColor.clearColor()
        }
        
        let btn = sender as! UIButton
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.init(red: 82/255.0, green: 195/255.0, blue: 241/255.0, alpha: 1)
        
        self.rechargeVC.view.hidden = true
        self.inquiry.view.hidden = true
        self.exchange.view.hidden = true
        self.imageScrollView.hidden = true
        self.myAccountVC.view.hidden = true
        self.imageScrollView.invalidateTimer()
        
        switch btn.tag {
        case 100:
            
            self.imageScrollView.setupTimer()
            self.imageScrollView.hidden = false
            
        case 101:
            
            self.rechargeVC.view.hidden = false
            
        case 102:
        
            self.inquiry.view.hidden = false
        
        case 103:
            
            self.exchange.view.hidden = false
            exchange.getProductList()

        default:
            
            self.myAccountVC.view.hidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageArrays = NSMutableArray.init(capacity: 0)
        self.creatSubviews()
    }
    
    
    func creatSubviews() {
        
        let frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50)
        
        self.rechargeVC = RechargingViewController()
        self.addChildViewController(self.rechargeVC)
        self.rechargeVC.view.frame = frame
        self.view.addSubview(self.rechargeVC.view)
        
        self.inquiry = InquiryViewController()
        self.addChildViewController(self.inquiry)
        self.inquiry.view.frame = frame
        self.view .addSubview(self.inquiry.view)
        
        self.exchange = ExchangeViewController()
        self.addChildViewController(self.exchange)
        self.exchange.view.frame = frame
        self.view .addSubview(self.exchange.view)
        
        self.myAccountVC = MyAccountViewController()
        self.addChildViewController(self.myAccountVC)
        self.myAccountVC.view.frame = frame
        self.view.addSubview(self.myAccountVC.view)
    
        self.imageScrollView = SDCycleScrollView.init(frame: frame, delegate: nil, placeholderImage:UIImage.init(named:"exchange"))
        imageScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.imageScrollView.autoScrollTimeInterval = 5.0
        self.view.addSubview(self.imageScrollView)
        
        self.imageScrollView.hidden = false
        rechargeVC.view.hidden = true
        inquiry.view.hidden = true
        exchange.view.hidden = true
        myAccountVC.view.hidden = true
        
        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/activity", params: nil, part: nil, success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                
                print(response.responseObject)
                self.carArray = response.responseObject["activityList"] as! NSArray
                self.showImageView()
            }
            else if(response.head.code == JYNeedLoginCodeNotification){
                
                let comment = CommentMethods()
                comment.goLogin(self)
                
            }
        }) { (request:BKRequestModel!, error:NSError!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
        }        
    }
    
    func showImageView() {
        
        for i in 0 ..< self.carArray.count {
            
            let imgUrl = self.carArray[i]["imgUrl"] as! String
            self.imageArrays.addObject(imgUrl)
        }
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue()) { [unowned self] in
            
            self.imageScrollView.imageURLStringsGroup = self.imageArrays as [AnyObject]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
