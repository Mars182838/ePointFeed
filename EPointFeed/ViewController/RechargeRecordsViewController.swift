//
//  RechargeRecordsViewController.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/17.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class RechargeRecordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!

    var dataSource:NSMutableArray?
    
    var currentPage: Int = 1
    var page: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.registerNib(UINib.init(nibName: "RechargeRecordsCell", bundle: nil), forCellReuseIdentifier: "RechargeRecordsCell")
        
        self.dataSource = []
        
        //设置导航栏颜色
        let mainColor = UIColor.init(hexString: "52C3F1")
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "充值记录"
        
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        self.getInformation()
        

        self.myTableView.addInfiniteScrollingWithActionHandler { 
            
            self.insertRowAtBottom()
        }
    }
    
    func insertRowAtBottom() {
        
        self.currentPage += 1;
        
        if (self.currentPage > Int(self.page as! String)!) {
       
            let view = UIView(frame:CGRectMake(0 , 0, self.myTableView.width, 52))
            view.backgroundColor = UIColor.clearColor()
            
            let containerView = UIView(frame:CGRectMake(0, 0, 100, 52))
            containerView.backgroundColor = UIColor.clearColor()
            view.addSubview(containerView)
            
            let imageView = UIImageView.init(image: UIImage.init(named: "ark_icon_smile"))
            imageView.frame = CGRectMake(0, 17, 15, 15)
            containerView.addSubview(imageView)
            
            let label = UILabel.init(frame: CGRectMake(23, 17, 80, 15))
            label.text = "没有更多了"
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = UIColor.init(hexString: "666666")
            containerView.addSubview(label)
            
            containerView.center = view.center

            self.myTableView.tableFooterView = view
            self.myTableView.showsInfiniteScrolling = false
        }
        else{
            self.getInformation()
        }
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK - getInformation
    
    func getInformation() {
        
        let dic:Dictionary <String,Int> = ["currentPage":self.currentPage]
        
        let params = ["data":CommentMethods().encWithPubKeyDictionary(dic)];
        
        BKRequestProxy.sharedInstance().requestWithType(BKRequestTypePOST, urlString: "/third/spdb/ePointRechargeHis", params: params, part: nil, success: { [unowned self] (request :BKRequestModel!, response:BKResponseModel!) in
            
            if (!response.responseObject.isKindOfClass(NSDictionary)) {

                self.myTableView.pullToRefreshView.stopAnimating()

                return ;
            }
            
            if (response.responseObject.isKindOfClass(NSDictionary) && JYSuccessCode == response.head.code) {
                                
                let products:NSArray = (response.responseObject["transHis"] as? NSArray)!
                self.page = (response.responseObject["pageCount"] as? String)
                
                if products.count > 0 {
                 
                    self.dataSource?.addObjectsFromArray(products as [AnyObject])
                    self.myTableView.reloadData()
                }
                
                self.myTableView.infiniteScrollingView.stopAnimating()
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
    
    // MARK - TableViewDelegate and TableViewDatasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.dataSource?.count)!
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        
        // 系统 cell 的简单用法
        let mycell : RechargeRecordsCell = tableView.dequeueReusableCellWithIdentifier("RechargeRecordsCell", forIndexPath: indexPath) as! RechargeRecordsCell
        let dataDic:NSDictionary = self.dataSource![indexPath.row] as! NSDictionary
        if (indexPath.row)%2 == 0 {
            
            mycell.contentView.backgroundColor = UIColor.whiteColor()
            
        }else{
            
            mycell.contentView.backgroundColor = UIColor.init(hexString: "F2F7FB")

        }
       
        mycell.updateUI(dataDic)
        
        return mycell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
