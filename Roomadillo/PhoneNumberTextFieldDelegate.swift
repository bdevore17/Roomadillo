//
//  PhoneNumberTextFieldDelegate.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/26/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation

class PhoneNumberTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        
        let decimalString = components.joinWithSeparator("") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
        {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne
        {
            formattedString.appendString("1 ")
            index += 1
        }
        if (length - index) > 3
        {
            let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substringFromIndex(index)
        formattedString.appendString(remainder)
        textField.text = formattedString as String
        return false
    }
}
