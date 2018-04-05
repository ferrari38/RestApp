//
//  StoreViewController.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/29.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeCategory: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeTel: UITextView!
    @IBOutlet weak var storePR: UITextView!
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background1.jpg")!)
        
        getInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInfo() {
        Alamofire.request("http://api.gnavi.co.jp/RestSearchAPI/20150630/",
                          parameters: [
                            "keyid": "1f8bb0ea4bbc0528b1b3cba3ae01484a",
                            "format": "json",
                            "id": self.id
                            
            ]).responseJSON { response in
                
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                
                if json["rest"]["image_url"]["shop_image1"].stringValue != "" {
                    let url = URL(string: json["rest"]["image_url"]["shop_image1"].stringValue)
                    self.storeImage.af_setImage(withURL: url!)
                }
                else {
                    let url = URL(string: "http://design-ec.com/d/e_others_50/m_e_others_501.png")
                    self.storeImage.af_setImage(withURL: url!)
                }
                
                self.storeName.text = json["rest"]["name"].stringValue
                self.storeCategory.text = json["rest"]["category"].stringValue
                self.storeTel.text = "TEL  " + json["rest"]["tel"].stringValue
                var pr = json["rest"]["pr"]["pr_short"].stringValue + "\n\n" + json["rest"]["pr"]["pr_long"].stringValue
                pr = pr.replacingOccurrences(of: "<BR>", with: "\n")
                self.storePR.text = pr
        }
    }
    
}
