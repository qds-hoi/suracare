//
//  RoundRectButton.swift
//  suracare
//
//  Created by hoi on 8/5/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation

import UIKit

/// UIButton subclass that draws a rounded rectangle in its background.

class RoundRectButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.layer.cornerRadius = 0.5 * self.bounds.size.height
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.clipsToBounds = true
    }
}