//
//  ViewController.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/27.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var segmentButton: UISegmentedControl!
    @IBOutlet weak var mkMapView: MKMapView!
    
    @IBOutlet weak var swParking: UISwitch!
    @IBOutlet weak var swMidnight: UISwitch!
    
    var locationManager: CLLocationManager!
    
    var lantitude = ""
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bg = UIColor(patternImage: UIImage(named: "background1.jpg")!)
        bg.withAlphaComponent(0.5)
        self.view.backgroundColor = bg
        
        mkMapView.delegate = self
        
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        
        if(CLLocationManager.locationServicesEnabled() == true){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print(("位置情報サービスの利用が制限されている利用できません。"))
            case .denied:
                print("位置情報の利用が許可されていないため利用できません。")
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        } else {
            //位置情報サービスがOFFの場合
            print("位置情報サービスがONになっていないため利用できません。")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSegmented(_ sender: Any) {
        var r = 0
        switch (sender as AnyObject).selectedSegmentIndex {
        case 1:
            r = 500
        case 2:
            r = 1000
        case 3:
            r = 2000
        case 4:
            r = 3000
        default:
            r = 300
        }
        let center = CLLocationCoordinate2DMake(Double(lantitude)!, Double(longitude)!)
        let circle = MKCircle(center: center, radius: CLLocationDistance(r))
        mkMapView.removeOverlays(mkMapView.overlays)
        mkMapView.add(circle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchSegue") {
            let resultview = segue.destination as! ResultViewController
            resultview.lantitude = self.lantitude
            resultview.longitude = self.longitude
            resultview.range = String(segmentButton.selectedSegmentIndex + 1)
            if(self.swParking.isOn) {
                resultview.parking = "1"
            } else {
                resultview.parking = "0"
            }
            if(self.swMidnight.isOn) {
                resultview.midnight = "1"
            } else {
                resultview.midnight = "0"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.lantitude = String(location.coordinate.latitude)
            self.longitude = String(location.coordinate.longitude)
            
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            
            let region = MKCoordinateRegionMake(center, span)
            mkMapView.setRegion(region, animated:true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            annotation.title = "現在地"
            mkMapView.addAnnotation(annotation)
            
            //print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            
            let circle = MKCircle(center: center, radius: 300)
            mkMapView.removeOverlays(mkMapView.overlays)
            mkMapView.add(circle)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        myCircleView.fillColor = UIColor.red
        myCircleView.strokeColor = UIColor.black
        myCircleView.alpha = 0.1
        myCircleView.lineWidth = 1.0
        
        return myCircleView
    }
    
}
