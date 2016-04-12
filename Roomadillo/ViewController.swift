//
//  ViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 2/23/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import Koloda
import Parse

class ViewController: UIViewController {
    
    private var numberOfCards : UInt = 0
    @IBOutlet var kolodaView: KolodaView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    var photos : [UIImage] = []
    var roommates : [Roommate] = []
    let user : User = PFUser.currentUser() as! User
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        rightButton.tintColor = UIColor.whiteColor()
        leftButton.tintColor = UIColor.whiteColor()
        user.roommate?.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if(error == nil){
                if(self.user.roommate!.viewed!.isEmpty) {
                    self.user.roommate!.viewed!.append(self.user.roommate!.objectId!)
                }
                self.loadRoommates()
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    func roommateViewed(index: Int) {
        //print(self.kolodaView.currentCardNumber)
        self.user.roommate?.viewed?.append(self.roommates[index].objectId!)
        self.user.roommate?.saveInBackground()
        //print(user.roommate)
    }
    
    func loadRoommates() {
        let query = PFQuery(className: "Roommate")
        query.whereKey("objectId", notContainedIn: (self.user.roommate?.viewed)!)
        query.limit = 3
        query.findObjectsInBackgroundWithBlock {
            (results:[PFObject]?, error: NSError?) -> Void in
            if(error == nil){
                if let roommates = results as? [Roommate] {
                    for roommate in roommates {
                        let file = roommate.photo
                        file?.getDataInBackgroundWithBlock {
                            (data: NSData?, error: NSError?) -> Void in
                            if(error == nil){
                                self.roommates.append(roommate)
                                self.photos.append(UIImage(data: data!)!)
                                self.numberOfCards = UInt(self.photos.count)
                                self.kolodaView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileSegue" {
            if let destination = segue.destinationViewController as? FullProfileViewController {
                destination.image = photos[kolodaView.currentCardNumber]
                destination.firstName = roommates[kolodaView.currentCardNumber].firstName
            }
        }
    }
    
}

//MARK: KolodaViewDelegate
extension ViewController: KolodaViewDelegate {
    
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        //Example: loading more cards
        roommateViewed(Int(index))
        PFCloud.callFunctionInBackground("userSwiped", withParameters: ["roommate": self.roommates[Int(index)].objectId!, "like": (direction == .Right)]) {
            (response: AnyObject?, error: NSError?) -> Void in
            if(error == nil){
                print(error)
                print(response)
                if(response as! Bool == true){
                    NSNotificationCenter.defaultCenter().postNotificationName("newMatchFound", object: nil)
                }
                print("hello from cloud code")
            }
        }
        //        if index >= 3 {
        //            numberOfCards = 6
        //            kolodaView.reloadData()
        //        }
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        loadRoommates()
        //Example: reloading
        // kolodaView.resetCurrentCardNumber()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        //UIApplication.sharedApplication().openURL(NSURL(string: "https://roomadillo-server.herokuapp.com/")!)
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
}

//MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        print("before")
        let profileView = NSBundle.mainBundle().loadNibNamed("profileView", owner: RoommateProfileView(), options: nil)[0] as! RoommateProfileView
        print("hello")
        profileView.nameLabel.text = roommates[Int(index)].firstName
        profileView.profileImageView.image = photos[Int(index)]
        return profileView
          //return UIImageView(image: photos[Int(index)])
    }
    
}

