//
//  UIViewControllerExtension.swift
//  suracare
//
//  Created by hoi on 7/28/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentErrorMessage(message: String? = nil) {
        let alertController = UIAlertController(title: Text.Dialogues.errorTitle, message: Text.Dialogues.errorMessage, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: Text.Dialogues.okayText, style: .Default, handler: nil)
        alertController.addAction(okayAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}