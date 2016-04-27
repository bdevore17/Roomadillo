//
//  MoreTableViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/26/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import Parse

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0){
            //perform update profile segue
            self.performSegueWithIdentifier("updateProfileSegue", sender: self)
        }
        else if(indexPath.section == 1){
            PFUser.logOut()
            self.performSegueWithIdentifier("logOutSegue", sender: self)
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
