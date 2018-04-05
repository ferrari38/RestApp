//
//  ResultViewController.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/28.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rests: [[String: String?]] = []
    
    var lantitude = ""
    var longitude = ""
    var range = ""
    var parking = ""
    var midnight = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        parking = "0"
        getResult()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 125
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "storeSegue") {
            let indexPath = tableView.indexPathForSelectedRow
            self.id = (rests[(indexPath?.row)!]["id"] as? String)!
            
            let pageView = segue.destination as! PageViewController
            pageView.id = self.id
        }
    }
    
    //sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //sectionのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "レストラン一覧"
    }
    
    //sectionの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rests.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultViewCell
        
        cell.storeName.text = " " + self.rests[indexPath.row]["name"]!!
        cell.storeCategory.text = " " + self.rests[indexPath.row]["category"]!!
        cell.storeHoliday.text = "定休日: " + self.rests[indexPath.row]["holiday"]!!
        cell.storeBudget.text = "平均予算: " + self.rests[indexPath.row]["budget"]!! + "円"
        
        let s:String = self.rests[indexPath.row]["station"]!!
        let w:String = self.rests[indexPath.row]["walk"]!!
        cell.storeAccess.text = s + " " + w + "分"
        
        if self.rests[indexPath.row]["image_url"]! != "" {
            let url = URL(string: self.rests[indexPath.row]["image_url"]!!)
            cell.image01.af_setImage(withURL: url!)
        } else {
            let url = URL(string: "http://design-ec.com/d/e_others_50/m_e_others_501.png")
            cell.image01.af_setImage(withURL: url!)
        }
        
        return cell
    }
    
    //cell選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //検索結果を取得
    func getResult() {
        Alamofire.request("http://api.gnavi.co.jp/RestSearchAPI/20150630/",
                          parameters: [
                            "keyid": "1f8bb0ea4bbc0528b1b3cba3ae01484a",
                            "format": "json",
                            "latitude": lantitude,
                            "longitude": longitude,
                            "range": range,
                            "midnight": midnight,
                            "parking": parking,
                            "hit_per_page": "20"
            ]).responseJSON { response in
                
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                let j = json["rest"]
                j.forEach{(_, j) in
                    let r: [String: String?] = [
                        "id": j["id"].stringValue,
                        "name": j["name"].stringValue,
                        "category": j["category"].stringValue,
                        "image_url": j["image_url"]["shop_image1"].stringValue,
                        "station": j["access"]["station"].stringValue,
                        "walk": j["access"]["walk"].stringValue,
                        "holiday": j["holiday"].stringValue,
                        "budget": j["budget"].stringValue
                    ]
                    self.rests.append(r)
                }
                //table更新
                self.tableView.reloadData()
        }
    }
}
