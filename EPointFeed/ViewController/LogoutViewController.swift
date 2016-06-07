//
//  LogoutViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/11.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    var isChecked :Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isChecked = false
        
        let backImage = UIImageView.init(frame: CGRectMake(0, 0, self.view.width, self.view.height - 50))
        backImage.image = UIImage.init(named: "exchange")
        self.view.addSubview(backImage)
        
        
    }
    
    func alterLogoutView() {
        
        let alterLogout = LogoutAlterView.init()
        alterLogout.show()
        
        alterLogout.initWithClosure { (selectIndex) in
            
            if selectIndex == 11{
                
                BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/logout", params: nil, part: nil, success: { (request :BKRequestModel!, response:BKResponseModel!) in
                    
                    if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                        
                        BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);

                        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(LogoutViewController.popToRootViewController), userInfo: nil, repeats: false)
                    }
                    else{
                        
                        BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);
                    }
                    
                }) { (request:BKRequestModel!, error:NSError!) in
                    
                    BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
                }

            }
            print(selectIndex)
        }
    }
    
    func popToRootViewController() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
