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
    @NSManaged var viewed : [String]?
    @NSManaged var phoneNumber : String?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    func indexInViewed(objectID: String) -> (index: Int, found: Bool) {
        if(viewed!.isEmpty) {
            return (0,false)
        }
        var low = 0;
        var high = viewed!.count - 1
        while (true) {
            let current = (low + high)/2
            if(viewed![current] == objectID) {
                return (current,true)
            } else if (low > high) {
                return (low,false)
            } else {
                if (viewed![current] > objectID) {
                    high = current - 1
                } else {
                    low = current + 1
                }
            }
        }
    }
    
}

