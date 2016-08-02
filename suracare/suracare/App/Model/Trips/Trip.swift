//
//  Trip.swift
//  suracare
//
//  Created by hoi on 7/27/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation


class Trip {
    let departure: NSDate
    let arrival: NSDate
    let actualDeparture: NSDate
    let delay: NSTimeInterval
    let delayed: Bool
    let duration: NSTimeInterval
    
    init(departure: NSDate, arrival: NSDate, actualDeparture: NSDate? = nil) {
        self.departure = departure
        self.arrival = arrival
        self.actualDeparture = actualDeparture ?? departure
        
        // calculations
        duration = self.arrival.timeIntervalSinceDate(self.departure)
        delay = self.actualDeparture.timeIntervalSinceDate(self.departure)
        delayed = delay > 0
    }
}