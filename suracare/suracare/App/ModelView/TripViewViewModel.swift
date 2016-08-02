//
//  TripViewViewModel.swift
//  suracare
//
//  Created by hoi on 7/27/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation


class TripViewViewModel {
    let date: String
    let departure: String
    let arrival: String
    let duration: String
    let delay: String?
    let delayHidden: Bool
    let departureTimeColor: UIColor
    
    init(_ trip: Trip) {
        date = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        departure = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        arrival = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        let durationFormatter = NSDateComponentsFormatter()
        durationFormatter.allowedUnits = [.Hour, .Minute]
        durationFormatter.unitsStyle = .Short
        duration = durationFormatter.stringFromTimeInterval(trip.duration)!
        
        delayHidden = !trip.delayed
        if trip.delayed {
            durationFormatter.unitsStyle = .Full
            delay = String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), durationFormatter.stringFromTimeInterval(trip.delay)!)
            departureTimeColor = .redColor()
        } else {
            self.delay = nil
            departureTimeColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        }
    }
}