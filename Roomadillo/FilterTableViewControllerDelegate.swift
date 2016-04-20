//
//  FilterTableViewControllerDelegate.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/13/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import Foundation

protocol FilterTableViewControllerDelegate {
    
    func filteringDidFinish(smoker: Bool?, studyinRoom: Bool?, earliestWakeUpTime: NSNumber?, latestWakeUpTime: NSNumber?, earliestBedtime: NSNumber?, latestBedtime: NSNumber?, cleanliness: NSNumber?)
}
