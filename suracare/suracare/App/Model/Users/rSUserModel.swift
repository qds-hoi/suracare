//
//  rSUserModel.swift
//  suracare
//
//  Created by hoi on 7/21/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation
import ReactiveCocoa

class rSUserModel : rSAppModel {
    var name: ConstantProperty<String>
    
    override init() {
        name = ""
    }
}