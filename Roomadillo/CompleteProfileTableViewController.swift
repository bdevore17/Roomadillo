//
//  CompleteProfileTableViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/12/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import Parse

class CompleteProfileTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var genderControl: UISegmentedControl!
    
    @IBOutlet var smokerControl: UISegmentedControl!
    
    @IBOutlet var studyControl: UISegmentedControl!
    
    @IBOutlet var wakeUpTextField: UITextField!
    @IBOutlet var bedTimeTextField: UITextField!
    
    @IBOutlet var cleanlinessSlider: UISlider!
    
    let datePicker = UIDatePicker()
    var wakeUpTime : NSDate?
    var bedTime : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .Time
        datePicker.date = NSDate()
        wakeUpTextField.inputView = datePicker
        wakeUpTextField.inputAccessoryView = Keyboard.doneButtonAccessoryView("wakeUpDonePressed",target: self)
        wakeUpTextField.delegate = self
        bedTimeTextField.inputView = datePicker
        bedTimeTextField.inputAccessoryView = Keyboard.doneButtonAccessoryView("bedTimeDonePressed", target: self)
        bedTimeTextField.delegate = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        if textField == wakeUpTextField {
            textField.text = dateFormatter.stringFromDate(datePicker.date)
            wakeUpTime = datePicker.date
        }
        else if textField == bedTimeTextField {
            textField.text = dateFormatter.stringFromDate(datePicker.date)
            bedTime = datePicker.date
        }
    }
    
    func wakeUpDonePressed() {
        wakeUpTextField.endEditing(true)
    }
    
    func bedTimeDonePressed() {
        bedTimeTextField.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.resignFirstResponder()
        let user = PFUser.currentUser() as? User
        let roommate = user?.roommate
        roommate?.male = genderControl.selectedSegmentIndex == 0
        roommate?.smoker = smokerControl.selectedSegmentIndex == 1
        roommate?.studyInRoom = smokerControl.selectedSegmentIndex == 0
        let calendar = NSCalendar.currentCalendar()
        var comp = calendar.components([.Hour, .Minute], fromDate: wakeUpTime!)
        roommate?.wakeUp = Double(comp.hour) + (Double(comp.minute) / 60)
        comp = calendar.components([.Hour, .Minute], fromDate:  bedTime!)
        roommate?.bedtime = Double(comp.hour) + (Double(comp.minute) / 60)
        roommate?.cleanliness = cleanlinessSlider.value
        roommate?.saveEventually()
        self.performSegueWithIdentifier("profileCompletedSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
