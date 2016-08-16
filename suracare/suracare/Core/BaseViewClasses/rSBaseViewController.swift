//
//  rSBaseViewController.swift
//  suracare
//
//  Created by hoi on 7/22/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit

class rSBaseViewController: UIViewController {

    class var uniqueName: String {
        return String.className(self)
    }
    
//    let validator = Validator()
//    var validationRules = [UITextField:ValidationRule]()
    
    var currentActiveTextField: UITextField?
    var currentActiveTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func bindViewModel() {
        fatalError("This method still not implement")
    }
    
    func unbindViewModel() {
        fatalError("This method still not implement")
    }

}
