//
//  ExchangeDetailViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/12.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class ExchangeDetailViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var navLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var dynamicTextField: UITextField!
    
    @IBOutlet weak var dynamicBtn: UIButton!
    
    @IBOutlet weak var startCheckBtn: UIButton!
    
    @IBOutlet weak var dynamicLabel: UILabel!
    
    @IBOutlet weak var detailNameLabel: UILabel!
    
    var exchangeModel:ExchangeProductModel?
    
    var timeout:String?
    var timeInterval = 0
    var minSMSSendInverval = 0
    var timer:NSTimer!
    var isTimeOut = true

    @IBAction func dynamicBtnClick(sender: AnyObject) {
    
        self.view.endEditing(true)
        
        if !(self.phoneTextField.text!.isValidPhone()) {
            
            let customView = CustomAlterView(stype: statusType.error)
            customView.changeTextTitle(value: "手机号码格式错误", detail: "请检查后重新输入", isInqiury: false)
            customView.show()
            
            return
        }
        
        let dic:Dictionary <String,String> = ["mobile":self.phoneTextField.text!]
        let params = ["data":CommentMethods().encWithPubKeyDictionary(dic)];
        
        BKCustomProgressHUD.sharedCustomProgressHUD().showHUDLoadingView()
        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST,
                                                        urlString: "/third/spdb/checkCode",
                                                           params: params,
                                                           part: nil,
                                                           success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().hiddenViewFast()
            
            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                
                self.timeout = response.responseObject["expiringSeconds"] as! String?
                
                self.minSMSSendInverval = Int(self.timeout!)!
                BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg)
                
                self.addTimer()
                self.dynamicBtn.enabled = false
            }
            else if(response.head.code == JYNeedLoginCodeNotification){
                
                let comment = CommentMethods()
                comment.goLogin(self)
                
            }
            else{
                
                BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg)
            }
            
        }) { (request:BKRequestModel!, error:NSError!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
        }
    }
    
    @IBAction func startCheckBtnClick(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if !(self.phoneTextField.text!.isValidPhone()) {
            
            let customView = CustomAlterView(stype: statusType.error)
            customView.changeTextTitle(value: "手机号码格式错误", detail: "请检查后重新输入", isInqiury: false)
            customView.show()
            
            return
        }
        
        //TODO
        let dic:Dictionary<String,String> = [   "mobile":phoneTextField.text!,
                                             "checkCode":dynamicTextField.text!,
                                             "productId":exchangeModel!.productId!,
                                                "buyNum":"1"]
        let params = ["data":CommentMethods().encWithPubKeyDictionary(dic)];
        
        BKCustomProgressHUD.sharedCustomProgressHUD().showHUDLoadingView()
        
        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST,
                                                        urlString: "/third/spdb/exchange",
                                                        params: params,
                                                        part: nil,
                                                        success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            
            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                
                BKCustomProgressHUD.sharedCustomProgressHUD().hiddenViewFast()
                
                let customView = CustomAlterView(stype: statusType.success)
                customView.changeTextTitle(value: "兑换成功", detail: "兑换码已发送至您" + self.phoneTextField.text!.formatCharatersPhone() + "的手机，请注意查收!", isInqiury: false)
                customView.show()
                customView.dismissClosure({ (type) in
                    
                    if type == statusType.success
                    {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }
            else if(response.head.code == JYNeedLoginCodeNotification){
                
                let comment = CommentMethods()
                comment.goLogin(self)
                
            }
            else{
                
                BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);
            }
            
        }) { (request:BKRequestModel!, error:NSError!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
        }

    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTextField.delegate = self;
        self.dynamicTextField.delegate = self;
        
        self.startCheckBtn.enabled = false
        self.dynamicBtn.enabled = false

        self.startCheckBtn.setBackgroundImage(UIImage.init(named: "login_brey_btn"), forState: UIControlState.Disabled)
        self.startCheckBtn.setBackgroundImage(UIImage.init(named: "login_blue_btn"), forState: UIControlState.Normal)
        
        self.navLabel.text = exchangeModel?.brandName
        self.detailLabel.text = "需要支付:  " + (exchangeModel?.pointPrice)! + (exchangeModel?.pointRescName)!
        self.detailNameLabel.text = exchangeModel?.productName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(RechargingViewController.textFieldTextDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    // MARK: - showTimeMethods
    
    func showTime(timer:NSTimer) {
        
        self.timeInterval += 1
        
        if self.timeInterval < minSMSSendInverval {
            
            let time = minSMSSendInverval - self.timeInterval
            isTimeOut = false
            
            self.dynamicLabel.text = String(time) + "S后重新获取"
            self.dynamicLabel.textColor = UIColor.init(hexString: "cccccc")
        }
        else{
            
            self.dynamicBtn.enabled = true;
            self.dynamicLabel.text = "获取验证码"
            self.dynamicLabel.textColor = UIColor.init(hexString: "36BEF2")
            self.timeInterval = 0
            isTimeOut = true
            self.removeTimer()
        }
    }

    
    func addTimer(){
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self,
                                                            selector: #selector(InquiryViewController.showTime(_:)),
                                                            userInfo: nil,
                                                            repeats: true);
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes);
    }
    
    func removeTimer(){
        self.timer.invalidate();
    }
    
    //MARK:- textFieldTextDidChange Methods
    /**textFieldNotification Methods*/
    func textFieldTextDidChange(notification: NSNotification){
        
        if (isTimeOut) {
            
            self.dynamicBtn.enabled = !(self.phoneTextField.text?.isEmpty)!
            if (self.phoneTextField.text?.isEmpty)! {
                
                self.dynamicLabel.textColor = UIColor.init(hexString: "cccccc")

            }
            else{
                
                self.dynamicLabel.textColor = UIColor.init(hexString: "36BEF2")
            }
        }
        else{
            
            self.dynamicBtn.enabled = isTimeOut;
            self.dynamicLabel.textColor = UIColor.init(hexString: "cccccc")
        }
        self.startCheckBtn.enabled = self.validatePassword();
    }
    
    func validatePassword() -> Bool {
        var isValidate = Bool()
        isValidate = false
        
        if (self.phoneTextField.text?.isEmpty == false && self.dynamicTextField.text?.isEmpty == false ) {
            
            isValidate = true;
        }
        
        return isValidate;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.isEqual(self.phoneTextField) {
            
            self.phoneTextField.text = textField.text
        }
        else if(textField.isEqual(self.dynamicTextField)){
            
            self.dynamicTextField.text = textField.text
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
