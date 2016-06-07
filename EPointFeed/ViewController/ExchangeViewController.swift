//
//  ExchangeViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/9.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var productList:NSArray?
    var exchangeProduct:ExchangeProductModel?
    var exchangeDic:NSDictionary?
    var isFinished:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFinished = false
    }

    func exchangeBtn(sender:UIButton) {

        self.exchangeDic = self.productList![sender.tag] as? NSDictionary
        
        let pointPrice = exchangeDic!["pointPrice"] as? NSNumber
        
        self.exchangeProduct = ExchangeProductModel()
        self.exchangeProduct?.pointPrice = pointPrice!.stringValue
        self.exchangeProduct?.brandName = exchangeDic!["brandName"] as? String
        self.exchangeProduct?.productId = exchangeDic!["productId"] as? String
        self.exchangeProduct?.pointRescName = exchangeDic!["pointRescName"] as? String
        self.exchangeProduct?.productName = exchangeDic!["productName"] as? String

        let exchangeDetailVC = ExchangeDetailViewController()
        exchangeDetailVC.exchangeModel = self.exchangeProduct!
        self.presentViewController(exchangeDetailVC, animated: true, completion: nil)
    }
    
    func getProductList(){
        
        if !(self.isFinished!) {

            BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/product_list", params: nil, part: nil, success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            
                if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                    
                    self.productList = response.responseObject["productList"] as? NSArray
                    self.updateUIWithProductList(self.productList!)
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
        
    }
    
    func updateUIWithProductList(array:NSArray){
        
        self.isFinished = true

        for i in 0  ..< array.count  {
        
            let customView = UIView()
            
            let image = UIImage.init(imageLiteral: "exchangeRect")
            let backImage = UIImageView()
            
            backImage.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            backImage.image = image
            customView .addSubview(backImage)
            
            customView.frame = CGRectMake(CGFloat(i)*image.size.width + 10*(1 + CGFloat(i)), 22, image.size.width, image.size.height)
            
            if i>1 {
                
                customView.frame = CGRectMake(CGFloat(i-2)*image.size.width + 10*(1 + CGFloat(i-2)), 22 * 2 + image.size.height, image.size.width, image.size.height)
            }
            
            let bigurl = array[i]["listImgUrl"] as! String
            let bigImage = UIImageView();
            bigImage.frame = CGRectMake((backImage.width - 240)/2, 2, 240, 240)
            bigImage.sd_setImageWithURL(NSURL.init(string: bigurl), placeholderImage: UIImage.init(named:"car1.jpg"))
            customView.addSubview(bigImage)
            
            let listurl = array[i]["bigImgUrl"] as! String
            let logoImage = UIImageView();
            logoImage.frame = CGRectMake(image.size.width - 65, 10, 50, 50)
            logoImage.sd_setImageWithURL(NSURL.init(string: listurl), placeholderImage: UIImage.init(named:"icon_img3"))
            customView.addSubview(logoImage)

            let label:UILabel = UILabel(frame: CGRect(x: 15, y: 230, width: 200, height: 30))
            label.text = array[i]["brandName"] as? String
            label.font = UIFont.boldSystemFontOfSize(30)
            customView.addSubview(label)
            
            let leftParentheses = "("
            let rightParentheses = ")"
            let city = array[i]["cityRuleDesc"] as! String
            let cityRuleDesc = leftParentheses + city + rightParentheses
            let detailString = array[i]["productName"] as! String
            let  totalString = detailString + "  " + cityRuleDesc
            let detailLabel:UILabel = UILabel(frame: CGRect(x: label.frame.origin.x, y: 265, width: 360, height: 30))
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.attributedText = self.attributeString(totalString, fontString: cityRuleDesc)
            customView.addSubview(detailLabel)
            
            let epointImage = UIImageView();
            epointImage.frame = CGRectMake(image.size.width - 120, 240, 118, 42)
            epointImage.image = UIImage.init(named: "rectBtn")
            customView.addSubview(epointImage)

            
            let pointRescName = array[i]["pointRescName"] as! String
            let pointPrice = array[i]["pointPrice"] as! NSNumber
            
            let epointLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: epointImage.frame.size.width-5, height: 42))
            epointLabel.font = UIFont.systemFontOfSize(20)
            epointLabel.attributedText = self.attributeString(pointPrice.stringValue + "  " +  pointRescName, fontString: pointRescName)
            epointLabel.textAlignment = NSTextAlignment.Right
            epointLabel.textColor = UIColor.whiteColor()
            epointImage.addSubview(epointLabel)
            
            let btn2:UIButton = UIButton(frame: customView.bounds)
            btn2.backgroundColor = UIColor.clearColor()
            btn2.tag = i
            btn2.addTarget(self, action: #selector(ExchangeViewController.exchangeBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            customView.addSubview(btn2)
            
            self.mainScrollView.addSubview(customView)
        }
    }
    
    func attributeString(lableString:String,fontString:String) -> NSAttributedString {
        
        let attributeString = NSMutableAttributedString(string:lableString)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11),
                                     range:NSMakeRange(lableString.characters.count - fontString.characters.count, fontString.characters.count))
        return attributeString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
 