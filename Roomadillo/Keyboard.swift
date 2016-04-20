//
//  Keyboard.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/12/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation
import UIKit

class Keyboard {
    
    static func doneButtonAccessoryView(selectorName : String, target : UIViewController) -> UIView
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        doneToolbar.backgroundColor = UIColor.groupTableViewBackgroundColor()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: target, action: Selector(selectorName))
        done.tintColor = UIColor(red: 255/255, green: 144/255, blue: 79/255, alpha: 1.0)
        
        let items : [UIBarButtonItem] = [flexSpace,done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
    
    
}