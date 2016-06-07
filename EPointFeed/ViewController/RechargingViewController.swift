//
//  RechargingViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/9.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class RechargingViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var rechargingBtn: UIButton!
    
    @IBOutlet weak var rechargeTextField: UITextField!
   
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var rechargePasswordTextField: UITextField!
    
    // MARK: - rechargingClick
    
    @IBAction func rechargingClick(sender: AnyObject) {
    
        self.view.endEditing(true)
        
        if !(self.phoneTextField.text!.isValidPhone()) {
            
            let customView = CustomAlterView(stype: statusType.error)
            customView.changeTextTitle(value: "手机号码格式错误", detail: "请检查后重新输入", isInqiury: false)
            customView.show()
            
            return
        }
       
        let dic:Dictionary<String,String> = ["mobile":phoneTextField.text!,"pwd":rechargePasswordTextField.text!,"pointAmt":rechargeTextField.text!]
        
        let params = ["data":CommentMethods().encWithPubKeyDictionary(dic)];
        
        BKCustomProgressHUD.sharedCustomProgressHUD().showHUDLoadingView()
        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/recharge", params: params, part: nil, success: {[unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
           
            BKCustomProgressHUD.sharedCustomProgressHUD().hiddenViewFast()

            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                
                let detailString = "客户" + self.phoneTextField.text!.formatCharatersPhone() + "已完成充值易积分:" + self.rechargeTextField.text! + "积分"
                let customView = CustomAlterView(stype: statusType.success)
                customView.changeTextTitle(value: "充值成功", detail: detailString, isInqiury: false)
                customView.show()
                customView.dismissClosure({ (type) in
                
                    if type == statusType.success
                    {
                        self.clearView()
                    }
                })
            }
            else if(response.head.code == JYNeedLoginCodeNotification){

                let comment = CommentMethods()
                comment.goLogin(self)
                
            }
            else{
                
                let customView = CustomAlterView(stype: statusType.error)
                customView.changeTextTitle(value: "充值失败", detail: response.head.msg!, isInqiury: false)
                customView.show()
            }
        }) { (request:BKRequestModel!, error:NSError!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTextField.delegate = self;
        self.rechargeTextField.delegate = self;
        self.rechargePasswordTextField.delegate = self;
        
        self.rechargingBtn.enabled = false
        
        self.rechargingBtn.setBackgroundImage(UIImage.init(named: "login_brey_btn"), forState: UIControlState.Disabled)
        self.rechargingBtn.setBackgroundImage(UIImage.init(named: "login_blue_btn"), forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(RechargingViewController.textFieldTextDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
    }
        
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    //MARK:- textFieldTextDidChange Methods
    /**textFieldNotification Methods*/
    func textFieldTextDidChange(notification: NSNotification){
        
        self.rechargingBtn.enabled = self.validatePassword();
    }
    
    func validatePassword() -> Bool {
        var isValidate = Bool()
        isValidate = false
        
        if (self.phoneTextField.text?.isEmpty == false && self.rechargeTextField.text?.isEmpty == false && self.rechargePasswordTextField.text?.isEmpty == false) {
            
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
        else if textField.isEqual(rechargePasswordTextField){
            
            self.rechargePasswordTextField.text = textField.text
        }
        else{
        
            self.rechargeTextField.text = textField.text
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func clearView() {
        
        self.phoneTextField.text = ""
        self.rechargePasswordTextField.text = ""
        self.rechargeTextField.text = ""
        self.rechargingBtn.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
