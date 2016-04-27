//
//  FullProfileViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/11/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import BEMAnalogClock

class FullProfileViewController: UIViewController {

   
    
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
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = image
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
    
    @IBAction func exitButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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
