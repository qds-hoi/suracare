//
//  UIViewExtension.swift
//  suracare
//
//  Created by hoi on 7/26/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation
import UIKit


extension UIView {

    class func loadNib() -> Self {
        return loadNib()
    }
    
    
    class func loadNib<T: UIView>(viewType: T.Type) -> T {
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as! T
    }
    
    
    
    class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    
    
    class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}