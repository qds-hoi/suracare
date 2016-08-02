//
//  Main Container View Controller
//  rSContainerViewController.swift
//  suracare
//
//  Created by hoi on 7/21/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit
import ReactiveCocoa

class rSContainerViewController: rSBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tripTableView: UITableView!
    
    
    var itemSelected: Int? = 1
    var originalFrame: CGRect = CGRectZero

    let trip = Trip(departure: NSDate(timeIntervalSince1970: 1444396193), arrival: NSDate(timeIntervalSince1970: 1444397193), actualDeparture: NSDate(timeIntervalSince1970: 1444396493))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
        self.initAppearanceFromBegin()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.tripTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                if let cell = tripTableView.cellForRowAtIndexPath(indexPath) {
                    originalFrame = cell.frame
                    UIView.animateWithDuration(0.3,
                                               delay: 0,
        
                                               options: [],
        
                                               animations: {
                                                cell.frame = self.tripTableView.bounds
                        },
        
                                               completion: { finised in })
                    return
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Bind ViewModel
    override func bindViewModel() {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    ///
    func initAppearanceFromBegin() {
        self.tripTableView.dataSource = self
        self.tripTableView.delegate = self
        self.tripTableView.registerNib(rSTripTableViewCell.nib, forCellReuseIdentifier: rSTripTableViewCell.reuseId)
        self.tripTableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tripTableView.rowHeight = UITableViewAutomaticDimension
        self.tripTableView.estimatedRowHeight = 300
    }
    
    // MARK: Table View delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(rSTripTableViewCell.reuseId, forIndexPath: indexPath) as! rSTripTableViewCell
        cell.trip = self.trip
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        
        
        if self.itemSelected != indexPath.row {
            self.originalFrame = cell.frame
            UIView.animateWithDuration(0.3,
                                       delay: 0,
                                       
                                       options: [.TransitionCrossDissolve],
                                       
                                       animations: {
                                        cell.frame = tableView.bounds
                },
                                       
                                       completion: { finised in
                                        self.itemSelected = indexPath.row
            })

        } else {
            
            UIView.animateWithDuration(0.3,
                                       delay: 0,
                                       
                                       options: [.TransitionCrossDissolve],
                                       
                                       animations: {
                                        cell.frame = self.originalFrame
                },
                                       
                                       completion: { finised in
                                        self.itemSelected = nil
                                        tableView.reloadData()

            })
        }
        
    }
    

    
    // MARK: Delegate functionality working
  
    
    

}
