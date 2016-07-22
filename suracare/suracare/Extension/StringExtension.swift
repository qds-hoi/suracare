//
//  StringExtension.swift
//  suracare
//
//  Created by hoi on 7/22/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation


extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}