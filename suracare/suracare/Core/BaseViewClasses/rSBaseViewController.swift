//
//  rSBaseViewController.swift
//  suracare
//
//  Created by hoi on 7/22/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit

class rSBaseViewController: UIViewController {

    class var reuseId: String {
        return String.className(self)
    }
    
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
