//
//  Roommate.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 3/29/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation
import Parse

class Roommate : PFObject, PFSubclassing {
    
    @NSManaged var firstName : String?
    @NSManaged var photo : PFFile?
    @NSManaged var male : Bool
    @NSManaged var smoker : Bool
    @NSManaged var studyInRoom : Bool
    @NSManaged var bedtime : NSNumber?
    @NSManaged var wakeUp : NSNumber?
    @NSManaged var cleanliness : NSNumber?
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Roommate"
    }
    
}
