//
//  RechargeRecordsCell.swift
//  EPointFeed
//
//  Created by 俊王 on 16/5/17.
//  Copyright © 2016年 EB. All rights reserved.
//

import UIKit

class RechargeRecordsCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var epointLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(dic:NSDictionary) {
        
        let amtNumber = dic["amt"] as! NSNumber
        
        var mobileString = dic["mobile"] as? String
        
        if mobileString?.characters.count > 0 {
            
            mobileString = mobileString!.formatCharatersPhone()
        }
        
        self.dateLabel.text = dic["time"] as? String
        self.epointLabel.text = String(amtNumber)
        self.phoneLabel.text = mobileString
    }
}
