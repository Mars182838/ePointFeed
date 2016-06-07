//
//  CommentMethods.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/12.
//  Copyright © 2016年 EB. All rights reserved.
//

extension String{
    
    /**将Dic转换为 JSONString */
    static func toJSONString(dict:NSDictionary!) -> NSString{
        
        var data: NSData?
        
        do {
            data = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        let strJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        return strJson!
    }
    
    public func validString() -> Bool{
        
        if !self.isEmpty && self != NSNull.init() {
            
            return true
        }
        
        return false
    }
}

class CommentMethods: NSObject {

    let pubkey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----"
    
    func encWithPubKeyDictionary(dic:NSDictionary) -> String {
        
        let originString = String.toJSONString(dic)
        
        let encWithPubKey:String
        // Demo: encrypt with public key
        encWithPubKey = RSA.encryptString(originString as String, publicKey: pubkey)
        
        return encWithPubKey
    }
    
    func goLogin(controller:UIViewController) {
        
        controller.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    static func timeStampToString(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        let timeSta:NSTimeInterval = string.doubleValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        
        let date = NSDate(timeIntervalSince1970: timeSta)
//        print(dateFormatter.stringFromDate(date))
        
        return dateFormatter.stringFromDate(date)
    }
    
}
