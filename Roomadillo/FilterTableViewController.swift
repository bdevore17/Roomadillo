//
//  FilterTableViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/13/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    
    @IBOutlet var smokerControl: UISegmentedControl!
    @IBOutlet var studyInRoomControl: UISegmentedControl!
    @IBOutlet var earliestWakeUpField: UITextField!
    @IBOutlet var latestWakeUpField: UITextField!
    @IBOutlet var earliestBedtimeField: UITextField!
    @IBOutlet var latestBedtimeField: UITextField!
    @IBOutlet var cleanlinessSwitch: UISwitch!
    @IBOutlet var cleanlinessSlider: UISlider!
    @IBOutlet var cleanlinessCell: UITableViewCell!
    @IBOutlet var filterWakeUpTimeSwitch: UISwitch!
    @IBOutlet var filterBedtimeSwitch: UISwitch!
    
    var delegate : FilterTableViewControllerDelegate?
    
    var earliestWakeup : NSDate?
    var latestWakeup : NSDate?
    var earliestBedtime : NSDate?
    var latestBedtime : NSDate?
    
    var datePicker : UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        cleanlinessCell.hidden = !(cleanlinessSwitch.on)
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .Time
        setUpTextField(earliestWakeUpField)
        setUpTextField(latestWakeUpField)
        setUpTextField(earliestBedtimeField)
        setUpTextField(latestBedtimeField)
        earliestWakeUpField.inputAccessoryView = Keyboard.doneButtonAccessoryView("earliestWakeUpDonePressed", target: self)
        latestWakeUpField.inputAccessoryView = Keyboard.doneButtonAccessoryView("latestWakeUpDonePressed", target: self)
        earliestBedtimeField.inputAccessoryView = Keyboard.doneButtonAccessoryView("earliestBedtimeDonePressed", target: self)
        latestBedtimeField.inputAccessoryView = Keyboard.doneButtonAccessoryView("latestBedtimeDonePressed", target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextField(textField : UITextField) {
        textField.delegate = self
        textField.inputView = datePicker
    }
    
    func disableWakeUp() {
        for i in 2...3 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 2))
            print(i)
            cell?.userInteractionEnabled = false
            for j in cell!.contentView.subviews {
                (j as? UILabel)?.alpha = 0.25
                (j as? UITextField)?.enabled = false
            }
        }
        earliestWakeUpField.text = ""
        latestWakeUpField.text = ""
    }
    
    func disableBedtime() {
        for i in 4...5 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 2))
            print(i)
            cell?.userInteractionEnabled = false
            for j in cell!.contentView.subviews {
                (j as? UILabel)?.alpha = 0.25
                (j as? UITextField)?.enabled = false
            }
        }
        earliestBedtimeField.text = ""
        latestBedtimeField.text = ""
    }
    
    func enableWakeUp() {
        for i in 2...3 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 2))
            print(i)
            cell?.userInteractionEnabled = true
            for j in cell!.contentView.subviews {
                print(j)
                (j as? UILabel)?.alpha = 1
                (j as? UITextField)?.enabled = true
            }
        }
    }
    
    func enableBedtime() {
        for i in 4...5 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 2))
            print(i)
            cell?.userInteractionEnabled = true
            for j in cell!.contentView.subviews {
                (j as? UILabel)?.alpha = 1
                (j as? UITextField)?.enabled = true
            }
        }
    }
    
    @IBAction func cleanlinessSwitchChanged(sender: UISwitch) {
        cleanlinessCell.hidden = !(cleanlinessSwitch.on)
    }
    
    
    @IBAction func filterButtonPressed(sender: UIBarButtonItem) {
        var smoker : Bool?
        var studyInRoom : Bool?
        var earliestWakeUpHour : NSNumber?
        var latestWakeUpHour : NSNumber?
        var earliestBedtimeHour : NSNumber?
        var latestBedtimeHour : NSNumber?
        var cleanlinessValue : NSNumber?
        if(smokerControl.selectedSegmentIndex > 0){
            smoker = (smokerControl.selectedSegmentIndex == 2)
        }
        if(studyInRoomControl.selectedSegmentIndex > 0){
            studyInRoom = (studyInRoomControl.selectedSegmentIndex == 1)
        }
        if(filterWakeUpTimeSwitch.on){
            let calendar = NSCalendar.currentCalendar()
            var comp = calendar.components([.Hour, .Minute], fromDate: earliestWakeup!)
            earliestWakeUpHour = Double(comp.hour) + (Double(comp.minute) / 60)
            comp = calendar.components([.Hour, .Minute], fromDate: latestWakeup!)
            latestWakeUpHour = Double(comp.hour) + (Double(comp.minute) / 60)
        }
        if(filterBedtimeSwitch.on){
            let calendar = NSCalendar.currentCalendar()
            var comp = calendar.components([.Hour, .Minute], fromDate: earliestBedtime!)
            earliestBedtimeHour = Double(comp.hour) + (Double(comp.minute) / 60)
            comp = calendar.components([.Hour, .Minute], fromDate: latestBedtime!)
            latestBedtimeHour = Double(comp.hour) + (Double(comp.minute) / 60)
        }
        if(cleanlinessSwitch.on){
            cleanlinessValue = cleanlinessSlider.value
        }
        delegate?.filteringDidFinish(smoker, studyinRoom: studyInRoom, earliestWakeUpTime: earliestWakeUpHour, latestWakeUpTime: latestWakeUpHour, earliestBedtime: earliestBedtimeHour, latestBedtime: latestBedtimeHour, cleanliness: cleanlinessValue)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func earliestWakeUpDonePressed() {
        earliestWakeUpField.endEditing(true)
    }

    func latestWakeUpDonePressed() {
        latestWakeUpField.endEditing(true)
    }

    func earliestBedtimeDonePressed() {
        earliestBedtimeField.endEditing(true)
    }

    func latestBedtimeDonePressed() {
        latestBedtimeField.endEditing(true)
    }
    
    @IBAction func filterWakeUpChanged(sender: UISwitch) {
        if(sender.on) {
            enableWakeUp()
        }
        else {
            disableWakeUp()
        }
    }
    
    @IBAction func filterBedtimeChanged(sender: UISwitch) {
        print("bedtime changed")
        if(sender.on) {
            enableBedtime()
        }
        else {
            disableBedtime()
        }
    }
    
    

}


extension FilterTableViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        textField.text = dateFormatter.stringFromDate(datePicker!.date)
        switch(textField) {
        case earliestWakeUpField:
            earliestWakeup = datePicker?.date
            break
        case latestWakeUpField:
        latestWakeup = datePicker?.date
            break
        case earliestBedtimeField:
            earliestBedtime = datePicker?.date
            break
        case latestBedtimeField:
            latestBedtime = datePicker?.date
            break
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var date : NSDate?
        switch(textField) {
        case earliestWakeUpField:
            date = earliestWakeup
            break
        case latestWakeUpField:
            date = latestWakeup
            break
        case earliestBedtimeField:
            date = earliestBedtime
            break
        case latestBedtimeField:
            date = latestBedtime
            break
        default:
            break
        }
        if date == nil {
            date = NSDate()
        }
        datePicker?.date = date!
    }
    
    
    
}