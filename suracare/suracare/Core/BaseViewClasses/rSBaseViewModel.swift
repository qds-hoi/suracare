//
//  rSBaseViewModel.swift
//  suracare
//
//  Created by hoi on 7/26/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation


class ViewModel: NSObject {
    
    
    let services: rSViewModelServicesProtocol
    
    weak var delegate: rSViewModelServicesDelegate?
    
    init(services: rSViewModelServicesProtocol) {
        self.services = services
        super.init()
    }
    
    
}