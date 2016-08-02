//
//  NSDateExtension.swift
//  suracare
//
//  Created by hoi on 7/28/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation

extension NSDate {
    ///Returns the time of a date formatted as "HH:mm" (e.g. 18:30)
    func formattedTime(formatter: NSDateFormatter)-> String {
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.stringFromDate(self)
    }
    
    ///Returns a string in "d M" format, e.g. 19/9 for June 19.
    func formattedDay(formatter: NSDateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.stringFromDate(self)
    }
    
    ///Returns the week day of the NSDate, e.g. Sunday.
    func dayOfWeek(formatter: NSDateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.stringFromDate(self)
    }
}