//
//  TripPresentationControl.swift
//  suracare
//
//  Created by hoi on 7/27/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation


class TripPresentationControl: NSObject {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    
    var trip: Trip? {
        didSet {
            guard let trip = self.trip else {
                return
            }
            
            dateLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
            departureTimeLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            arrivalTimeLabel.text  = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            
            let durationFormatter = NSDateComponentsFormatter()
            durationFormatter.allowedUnits = [.Hour, .Minute]
            durationFormatter.unitsStyle = .Short
            durationLabel.text = durationFormatter.stringFromTimeInterval(trip.duration)!
            
            delayLabel.hidden = !trip.delayed
            if trip.delayed {
                durationFormatter.unitsStyle = .Full
                delayLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), durationFormatter.stringFromTimeInterval(trip.delay)!)
                departureTimeLabel.textColor = .redColor()
            }
        }
    }
}