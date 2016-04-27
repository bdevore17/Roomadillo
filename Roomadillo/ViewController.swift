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
import JDStatusBarNotification
import KVNProgress
import SIAlertView

class ViewController: UIViewController {
    
    private var numberOfCards : UInt = 0
    @IBOutlet var kolodaView: KolodaView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    var photos : [UIImage] = []
    var roommates : [Roommate] = []
    let user : User = PFUser.currentUser() as! User
    var filterQuery : PFQuery?
    var profileUpdated = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateNeeded), name: "userProfileUpdated", object: nil)
        
    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        rightButton.tintColor = UIColor.whiteColor()
        leftButton.tintColor = UIColor.whiteColor()
        setKVNConfiguration()
        statusBarSetup()
        KVNProgress.showWithStatus("Loading")
        user.roommate?.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if(error == nil){
                if(self.user.viewed!.isEmpty) {
                    self.user.viewed!.append(self.user.roommate!.objectId!)
                }
                self.loadRoommates(self.filterQuery)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(profileUpdated){
            profileUpdated = false
            loadRoommates(filterQuery)
        }
    }
    
    func updateNeeded() {
        profileUpdated = true
    }
    
    func setKVNConfiguration() {
        let configuration = KVNProgressConfiguration.defaultConfiguration()
        configuration.backgroundTintColor = UIColor(red: 0/255, green: 85/255, blue: 128/255, alpha: 1.0)
        configuration.backgroundFillColor = UIColor(red: 0/255, green: 85/255, blue: 128/255, alpha: 1.0)
        configuration.errorColor = UIColor.whiteColor()
        configuration.statusColor = UIColor.whiteColor()
        configuration.circleStrokeForegroundColor = UIColor.whiteColor()
        configuration.minimumErrorDisplayTime = 3
        KVNProgress.setConfiguration(configuration)
    }
    
    func statusBarSetup() {
        JDStatusBarNotification.addStyleNamed("roomadilloStyle") {
            style in
            style.barColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
            style.textColor = UIColor.whiteColor()
            style.animationType = .Bounce
            style.font = UIFont(name: "Futura-Medium", size: 12.0)
            return style
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
        self.user.viewed?.append(self.roommates[index].objectId!)
        self.user.saveEventually()
        //print(user.roommate)
    }
    
    func loadRoommates(q : PFQuery?) {
        KVNProgress.showWithStatus("Loading")
        roommates = []
        photos = []
        self.numberOfCards = 0
        kolodaView.resetCurrentCardNumber()
        print("load Roommates")
        var query = q?.copy() as? PFQuery
        if(query == nil){
            print("query is nil")
            query = PFQuery(className: "Roommate")
        }
        query!.whereKey("objectId", notContainedIn: (self.user.viewed)!)
        query!.limit = 3
        query!.whereKey("male", equalTo: user.roommate!.male)
        query!.findObjectsInBackgroundWithBlock {
            (results:[PFObject]?, error: NSError?) -> Void in
            if(error == nil){
                if let roommates = results as? [Roommate] {
                    for roommate in roommates {
                        let file = roommate.photo
                        print(roommate.firstName)
                        file?.getDataInBackgroundWithBlock {
                            (data: NSData?, error: NSError?) -> Void in
                            if(error == nil){
                                self.roommates.append(roommate)
                                self.photos.append(UIImage(data: data!)!)
                                self.numberOfCards = UInt(self.photos.count)
                                if(self.photos.count == roommates.count){
                                    KVNProgress.dismiss()
                                    self.kolodaView.reloadData()
                                }
                            }
                        }
                    }
                    if roommates.count == 0 {
                        let delay = 1 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            KVNProgress.showErrorWithStatus("No Profiles to Show.")
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
                destination.roommateData = roommates[kolodaView.currentCardNumber]
            }
        }
        else if segue.identifier == "filterSegue" {
            if let destination = segue.destinationViewController as? FilterTableViewController {
                destination.delegate = self
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
                    JDStatusBarNotification.showWithStatus("Match Found!", dismissAfter: 2.0, styleName: "roomadilloStyle")
                }
                print("hello from cloud code")
            }
        }
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        print(photos.count)
        print("did Run out of cards")
        loadRoommates(filterQuery)
        //Example: reloading
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
}

//MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func koloda(kolodaNumberOfCards koloda: KolodaView) -> UInt {
        print("kolada number of cards \(numberOfCards)")
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let profileView = NSBundle.mainBundle().loadNibNamed("profileView", owner: RoommateProfileView(), options: nil)[0] as! RoommateProfileView
        print("index \(index)")
        profileView.nameLabel.text = roommates[Int(index)].firstName
        profileView.profileImageView.image = photos[Int(index)]
        return profileView
        //return UIImageView(image: photos[Int(index)])
    }
}

//MARK: FilterTableViewControllerDelegate
extension ViewController: FilterTableViewControllerDelegate {
    
    func filteringDidFinish(smoker: Bool?, studyinRoom: Bool?, earliestWakeUpTime: NSNumber?, latestWakeUpTime: NSNumber?, earliestBedtime: NSNumber?, latestBedtime: NSNumber?, cleanliness: NSNumber?) {
        filterQuery = PFQuery(className: "Roommate")
        if let smoker = smoker {
            filterQuery!.whereKey("smoker", equalTo: smoker)
        }
        if let studyinRoom = studyinRoom {
            filterQuery!.whereKey("studyInRoom", equalTo: studyinRoom)
        }
        if earliestWakeUpTime != nil && latestWakeUpTime != nil {
            filterHours(earliestWakeUpTime!, latestHour: latestWakeUpTime!, key: "wakeUp")
        }
        if earliestBedtime != nil && latestBedtime != nil {
            filterHours(earliestBedtime!, latestHour: latestBedtime!, key: "bedtime")
        }
        if cleanliness != nil {
            filterQuery?.whereKey("cleanliness", lessThanOrEqualTo: Double(cleanliness!)+1)
            filterQuery?.whereKey("cleanliness", greaterThanOrEqualTo: Double(cleanliness!)-1)
        }
        loadRoommates(filterQuery)
    }
    
    func filterHours(earliestHour: NSNumber, latestHour: NSNumber, key: String){
        if(Double(earliestHour) < Double(latestHour)) {
            filterQuery?.whereKey(key, greaterThanOrEqualTo: earliestHour)
            filterQuery?.whereKey(key, lessThanOrEqualTo: latestHour)
            return
        }
        print("special Case")
        let orQuery = filterQuery?.copy() as! PFQuery
        print(filterQuery)
        orQuery.whereKey(key, greaterThanOrEqualTo: earliestHour)
        filterQuery?.whereKey(key, lessThanOrEqualTo: latestHour)
        filterQuery = PFQuery.orQueryWithSubqueries([filterQuery!,orQuery])
    }
}