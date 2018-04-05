///Users/katsushiohzawa/Documents/Xcode/RestApp/RestApp/ResultViewCell.swift
//  ResultViewCell.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/29.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit

class ResultViewCell: UITableViewCell {
    @IBOutlet weak var image01: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeCategory: UILabel!
    @IBOutlet weak var storeAccess: UILabel!
    @IBOutlet weak var storeHoliday: UILabel!
    @IBOutlet weak var storeBudget: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(patternImage: UIImage(named: "background1.jpg")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
