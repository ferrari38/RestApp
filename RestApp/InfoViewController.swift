//
//  InfoViewController.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/30.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var id = ""
    
    var tableArray = ["name", "tel", "address", "access", "opentime", "holiday",
                      "budget", "credit_card", "parking_lots", "url", "url_mobile"]
    var tableLabel = ["店名", "電話番号", "住所", "アクセス", "営業時間", "定休日",
                      "平均予算", "クレジットカード", "駐車場", "ホームページ", "ホームページ（モバイル）"]
    var tableInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //sectionのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本情報"
    }
    
    //sectionの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInfo.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoViewCell
        let text = NSMutableAttributedString(string: self.tableLabel[indexPath.row] + "\n\n" + self.tableInfo[indexPath.row])
        text.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0, length:self.tableLabel[indexPath.row].count))
        text.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 10.0), range: NSRange(location:0, length:self.tableLabel[indexPath.row].count))
        cell.infoText.attributedText = text
        return cell
    }
    
    //cell選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                for t in self.tableArray {
                    if(t == "access") {
                        let i1 = json["rest"]["access"]["station"].stringValue
                        let i2 = json["rest"]["access"]["walk"].stringValue
                        let i = i1 + " " + i2 + "分"
                        self.tableInfo.append(i)
                    }
                    else if(t == "budget") {
                        var i = json["rest"][t].stringValue
                        i = i + "円"
                        self.tableInfo.append(i)
                    }
                    else if(t == "parking_lots") {
                        var i = json["rest"][t].stringValue
                        i = i + "台"
                        self.tableInfo.append(i)
                    }
                    else {
                        var i = json["rest"][t].stringValue
                        i = i.replacingOccurrences(of: "<BR>", with: "\n")
                        self.tableInfo.append(i)
                    }
                }
                self.tableView.reloadData()
        }
    }

}
