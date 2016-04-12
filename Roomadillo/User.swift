//
//  User.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 3/29/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation
import Parse

class User : PFUser {
    
    @NSManaged var firstName : String?
    @NSManaged var lastName : String?
    @NSManaged var roommate : Roommate?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
}

