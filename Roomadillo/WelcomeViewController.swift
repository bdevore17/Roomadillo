//
//  WelcomeViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 3/29/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectWithFacebook(sender: UIButton) {
        self.view.userInteractionEnabled = false
        let permissionsArray = ["public_profile", "email", "user_friends"]
        PFUser.logOut()
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissionsArray) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user as? User {
                //                let installation = PFInstallation.currentInstallation()
                //                installation["user"] = user
                //                installation.saveEventually()
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    self.fetchData()
                }
                else if user.phoneNumber == nil {
                    self.performSegueWithIdentifier("welcomeSegue", sender: self)
                }
                else {
                    print("User logged in through Facebook!")
                    self.performSegueWithIdentifier("loggedInSegue", sender: self)
                }
            } else {
                print(error?.description)
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func fetchData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.height(1500), email, age_range"])
        graphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error: \(error)")
                self.view.userInteractionEnabled = true
                return
            }
            let user : User = PFUser.currentUser() as! User
            let roommate = Roommate()
            let acl = PFACL()
            acl.publicReadAccess = true
            acl.publicWriteAccess = false
            acl.setWriteAccess(true, forUser: user)
            roommate.ACL = acl
            if let photoURL = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                let profilepictureURL = NSURL(string: photoURL)
                let photo = NSData(contentsOfURL: profilepictureURL!)
                let file = PFFile(name: "profile_pic.png", data: photo!)
                roommate.photo = file
            }
            if let userEmail = result.valueForKey("email") as? String {
                print("User Email is: \(userEmail)")
                user.email = userEmail
            }
            user.firstName = result.valueForKey("first_name") as? String
            roommate.firstName = user.firstName
            user.lastName = result.valueForKey("last_name") as? String
            user.viewed = []
            user.roommate = roommate
//            user.ACL = PFACL(user: user)
            PFObject.saveAllInBackground([user,roommate]) {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("Facebook success")
                    self.performSegueWithIdentifier("welcomeSegue", sender: self)
                } else {
                    self.view.userInteractionEnabled = true
                    
                }
            }
        })
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
