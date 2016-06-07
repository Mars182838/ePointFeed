//
//  ViewController.swift
//  EPointFeedback
//
//  Created by 俊王 on 16/5/6.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginHeader: UIView!
    
    @IBOutlet weak var loginTextFieldView: UIView!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: -loginBtnClickMethod
    @IBAction func loginBtnClick(sender: AnyObject){
        
        self.view.endEditing(true)

        // TODO
        let dic:Dictionary<String,String> = ["userNo":phoneTextField.text!,"loginPwd":passwordTextField.text!]
        
        let params = ["data":CommentMethods().encWithPubKeyDictionary(dic)];
        
        BKCustomProgressHUD.sharedCustomProgressHUD().showHUDLoadingView()

        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/login", params: params, part: nil, success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            
            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
             
                BKCustomProgressHUD.sharedCustomProgressHUD().hiddenViewFast()
                
                let firstVC = FirstViewController()
                self.navigationController?.pushViewController(firstVC, animated: true)
            }
            else{
                
                BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage(response.head.msg);
            }
            
        }) { (request:BKRequestModel!, error:NSError!) in
            
            BKCustomProgressHUD.sharedCustomProgressHUD().showHUdModeTextViewWithMessage("网络状态不佳，请稍后再试试哦!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTextField.delegate = self;
        self.passwordTextField.delegate = self;
        
        self.navigationController?.navigationBarHidden = true
        
        self.loginTextFieldView.alpha = 0
        
        self.loginBtn.enabled = false
        
        self.loginBtn.setBackgroundImage(UIImage.init(named: "login_brey_btn"), forState: UIControlState.Disabled)
        self.loginBtn.setBackgroundImage(UIImage.init(named: "login_blue_btn"), forState: UIControlState.Normal)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animateWithDuration(1.0, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [unowned self] in
            
            self.loginHeader.frame = CGRectMake(0, 180, self.loginHeader.frame.width, self.loginHeader.frame.height)
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.loginTextFieldView.alpha = 1
                
                self.loginTextFieldView.frame = CGRectMake(0, 450, self.loginTextFieldView.frame.width, self.loginTextFieldView.frame.height)
                }, completion: nil)
            
            }, completion:{(finished:Bool) -> Void in
            
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.textFieldTextDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    //MARK:- textFieldTextDidChange Methods
    /**textFieldNotification Methods*/
    func textFieldTextDidChange(notification: NSNotification){
        
        self.loginBtn.enabled = self.validatePassword();
    }
    
    
    func validatePassword() -> Bool {
        
        var isValidate = Bool()
        
        isValidate = false
        
        if (self.phoneTextField.text != nil && self.phoneTextField.text?.isEmpty == false && self.passwordTextField.text != nil && self.passwordTextField.text?.isEmpty == false) {
            
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
        else{
            
            self.passwordTextField.text = textField.text
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



