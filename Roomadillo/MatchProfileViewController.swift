//
//  MatchProfileViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/25/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit

import UIKit
import BEMAnalogClock
import Parse
import MessageUI

class MatchProfileViewController: UIViewController {
    
    @IBOutlet var smokerLabel: UILabel!
    @IBOutlet var smokerImage: UIImageView!
    @IBOutlet var studyInRoomLabel: UILabel!
    @IBOutlet var studyInRoomImage: UIImageView!
    @IBOutlet var cleanlinessLabel: UILabel!
    @IBOutlet var wakeUpLabel: UILabel!
    @IBOutlet var bedtimeLabel: UILabel!
    @IBOutlet var bedtimeClock: BEMAnalogClockView!
    @IBOutlet var wakeUpClock: BEMAnalogClockView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    var roommateData : Roommate!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var textButton: UIButton!
    var phoneNumber : String?
    var user = PFUser.currentUser() as! User
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoneNumbers()
        setProfileImage()
        nameLabel.text = roommateData?.firstName
        
        wakeUpClock.hours = Int(roommateData.wakeUp!)
        wakeUpClock.minutes = Int((Double(roommateData.wakeUp!) - Double(Int(roommateData.wakeUp!))) * 60)
        wakeUpClock.faceBackgroundColor = UIColor(red: 0/255, green: 85/255, blue: 128/255, alpha: 1.0)
        wakeUpClock.hourHandColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
        wakeUpClock.minuteHandColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
        
        bedtimeClock.hours = Int(roommateData.bedtime!)
        bedtimeClock.minutes = Int((Double(roommateData.bedtime!) - Double(Int(roommateData.bedtime!))) * 60)
        bedtimeClock.faceBackgroundColor = UIColor(red: 0/255, green: 85/255, blue: 128/255, alpha: 1.0)
        bedtimeClock.hourHandColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
        bedtimeClock.minuteHandColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
        
        bedtimeLabel.text = "\(timeString(bedtimeClock.hours, minute: bedtimeClock.minutes))\nBedtime"
        wakeUpLabel.text = "\(timeString(wakeUpClock.hours, minute: wakeUpClock.minutes))\nWake Up"
        
        if(roommateData.smoker){
            smokerImage.image = UIImage(named: "Smoker")
            smokerLabel.text = "Smoker"
        }
        if(roommateData.studyInRoom){
            studyInRoomImage.image = UIImage(named: "StudyInRoom")
            studyInRoomLabel.text = "Studies in Room"
        }
        
        let formatter = NSNumberFormatter()
        formatter.maximumSignificantDigits = 2
        cleanlinessLabel.text = formatter.stringFromNumber(roommateData.cleanliness!)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0).CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timeString(hour : Int, minute: Int) -> String{
        var suffix = "AM"
        let formatter = NSNumberFormatter()
        formatter.paddingPosition = .BeforePrefix
        formatter.paddingCharacter = "0"
        formatter.minimumIntegerDigits = 2
        var h = hour
        if(h > 12){
            h -= 12
            suffix = "PM"
        }
        else if(h == 12){
            suffix = "PM"
        }
        else if(h == 0) {
            h = 12
        }
        let m = formatter.stringFromNumber(minute)!
        return "\(h):\(m) \(suffix)"
    }
    
    func getPhoneNumbers() {
        PFCloud.callFunctionInBackground("getUserInfo", withParameters: ["roommateId":roommateData.objectId!]) {
            (response: AnyObject?, error: NSError?) -> Void in
            if(error == nil) {
                print(response)
                self.phoneNumber = response as? String
                self.callButton.enabled = true
                self.callButton.alpha = 1
                self.textButton.enabled = true
                self.textButton.alpha = 1
            }
        }
    }
    
    func setProfileImage() {
        roommateData.photo?.getDataInBackgroundWithBlock {
            (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func callButtonPressed(sender: UIButton) {
        let phone = "tel://"+phoneNumber!;
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }
    
    @IBAction func textButtonPressed(sender: UIButton) {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = [phoneNumber!]
        messageComposeVC.body = "Hey \(roommateData.firstName!)! This is \(user.firstName!). We matched each other on Roomadillo."
        presentViewController(messageComposeVC, animated: true, completion: nil)
    }
}

extension MatchProfileViewController : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
