//
//  MyAccountViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/17.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    @IBAction func enterRechargeList(sender: AnyObject) {
    
        let rechargeVC = RechargeRecordsViewController()
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }

    @IBAction func logoutClick(sender: AnyObject) {
        
        self.alterLogoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        
    }
  
    func alterLogoutView() {
        
        let alterLogout = LogoutAlterView.init()
        alterLogout.show()
        
        alterLogout.initWithClosure { (selectIndex) in
            
            if selectIndex == 11{
                
                BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/logout", params: nil, part: nil, success: {[unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
                    
                    if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                        
                        BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);
                        
                        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(MyAccountViewController.popToRootViewController), userInfo: nil, repeats: false)
                    }
                    else{
                        
                        BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);
                    }
                    
                }) { (request:BKRequestModel!, error:NSError!) in
                    
                    BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
                }
                
            }
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
