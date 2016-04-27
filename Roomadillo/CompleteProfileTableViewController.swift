//
//  CompleteProfileTableViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/12/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit
import Parse
import SIAlertView

class CompleteProfileTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var phoneNumberField: UITextField!
    
    @IBOutlet var genderControl: UISegmentedControl!
    
    @IBOutlet var smokerControl: UISegmentedControl!
    
    @IBOutlet var studyControl: UISegmentedControl!
    
    @IBOutlet var wakeUpTextField: UITextField!
    @IBOutlet var bedTimeTextField: UITextField!
    
    @IBOutlet var cleanlinessSlider: UISlider!
    var phoneNumberDelegate = PhoneNumberTextFieldDelegate()
    
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
        phoneNumberField.delegate = phoneNumberDelegate
        phoneNumberField.inputAccessoryView = Keyboard.doneButtonAccessoryView("phoneNumberDonePressed", target: self)
        
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
    
    func phoneNumberDonePressed() {
        phoneNumberField.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.resignFirstResponder()
        
        if(!checkFields()) {
            return
        }
        
        let user = PFUser.currentUser() as? User
        user?.phoneNumber = self.phoneNumberField.text
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
        PFObject.saveAllInBackground([user!, roommate!]) {
            (success: Bool, error: NSError?) -> Void in
            if(error == nil) {
                self.performSegueWithIdentifier("profileCompletedSegue", sender: self)
            }
            else {
                print(error?.description)
            }

        }
    }
    
    func checkFields() -> Bool {
        if(phoneNumberField.text?.characters.count != 14) {
            throwAlert("Phone Number")
            return false
        }
        else if(wakeUpTime == nil) {
            throwAlert("Wake Up Time")
            return false
        }
        else if(bedTime == nil) {
            throwAlert("Bedtime")
            return false
        }
        return true
    }
    
    func throwAlert(fieldName: String) {
        let alertView = SIAlertView(title: "\(fieldName) Not Valid!", andMessage: "Please enter a valid \(fieldName.lowercaseString).")
        alertView.cornerRadius = 10
        alertView.backgroundStyle = .Gradient
        alertView.addButtonWithTitle("Got it!", type: .Cancel, handler: nil)
        alertView.titleFont = UIFont(name: "Futura-Medium", size: 20.0)
        alertView.buttonFont = UIFont(name: "Futura-Medium", size: 14.0)
        alertView.messageFont = UIFont(name: "Futura-Medium", size: 16.0)
        alertView.cancelButtonColor = UIColor.redColor()
        alertView.show()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
