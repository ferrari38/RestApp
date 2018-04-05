//
//  PageViewController.swift
//  RestApp
//
//  Created by KatsushiOhzawa on 2018/03/29.
//  Copyright © 2018年 KatsushiOhzawa. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setViewControllers([getFirst()], direction: .reverse, animated: true, completion: nil)
        self.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFirst() -> StoreViewController {
        let storeViewController = storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
        storeViewController.id = self.id
        return storeViewController
    }
    
    func getSecond() -> InfoViewController {
        let infoViewController = storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        infoViewController.id = self.id
        return infoViewController
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 左に進む動き
        if viewController.isKind(of: InfoViewController.self)
        {
            return getFirst()
            
        } else {
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        // 右に進む
        if viewController.isKind(of: StoreViewController.self)
        {
            // 1 -> 2
            return getSecond()
        } else {
            // 3 -> end of the road
            return nil
        }
    }

}
