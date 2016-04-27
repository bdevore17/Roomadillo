//
//  MatchesTableViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/5/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewController: UITableViewController {
    
    let user = PFUser.currentUser() as! User
    var matches : [Roommate] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchesTableViewController.loadMatches), name: "newMatchFound", object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadMatches()
    }
    
    func loadMatches() {
        print("loadMatches")
        let query1 = PFQuery(className: "Swipe")
        query1.whereKey("roommate1", equalTo: user.roommate!)
        query1.whereKey("r1LikesR2", equalTo: true)
        query1.whereKey("r2LikesR1", equalTo: true)
        let query2 = PFQuery(className: "Swipe")
        query2.whereKey("roommate2", equalTo: user.roommate!)
        query2.whereKey("r1LikesR2", equalTo: true)
        query2.whereKey("r2LikesR1", equalTo: true)
        let query = PFQuery.orQueryWithSubqueries([query1,query2])
        query.includeKeys(["roommate1", "roommate2"])
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let swipes = objects as? [Swipe] {
                self.matches = []
                for swipe in swipes {
                    var match = swipe.roommate1
                    //print(swipe.roommate1?.objectId == self.user.roommate?.objectId)
                    if(match?.objectId == self.user.roommate?.objectId){
                        print("inside it")
                        match = swipe.roommate2
                    }
                    self.matches.append(match!)
                }
                self.tableView.reloadData()
                print(self.matches)
            }
            else {
                print("ben")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MatchTableViewCell
        // Configure the cell...
        cell.nameLabel.text = matches[indexPath.row].firstName
        let matchImageFile = matches[indexPath.row].photo
        if let file = matchImageFile {
            file.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let photo = UIImage(data:imageData)
                        cell.photoView.image = photo
                    }
                }
            }
        }
        else {
            //cell.photoView.image = UIImage(named: "Logo")
        }
        
        //cell.jobDescription.sizeToFit()=
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "matchSegue" {
            if let destination = segue.destinationViewController as? MatchProfileViewController {
                destination.roommateData = matches[tableView.indexPathForSelectedRow!.row]
                tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
            }
        }
    }

}
