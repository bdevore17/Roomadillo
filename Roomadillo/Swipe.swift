//
//  Swipe.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/3/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation
import Parse

class Swipe : PFObject, PFSubclassing {
    
    @NSManaged var roommate1 : Roommate?
    @NSManaged var roommate2 : Roommate?
    @NSManaged var r1LikedR2 : Bool
    @NSManaged var r2LikedR1 : Bool
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Swipe"
    }
}