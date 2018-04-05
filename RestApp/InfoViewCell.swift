//
//  InfoViewCell.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/30.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit

class InfoViewCell: UITableViewCell {
    
    @IBOutlet weak var infoText: UITextView!
    
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
