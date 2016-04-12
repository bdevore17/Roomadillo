//
//  TabBarViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/6/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.incrementBadges), name: "newMatchFound", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func incrementBadges() {
        if let badge = self.tabBar.items?[1].badgeValue {
            if let badgeNum = Int(badge) {
                self.tabBar.items![1].badgeValue = "\(badgeNum+1)"
            }
        }
        else {
            self.tabBar.items![1].badgeValue = "1"
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item == tabBar.items![1]){
            self.tabBar.items![1].badgeValue = nil
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
