//
//  rSTripTableViewCell.swift
//  suracare
//
//  Created by hoi on 7/27/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit

class rSTripTableViewCell: rSBaseTableViewCell {
    
    @IBOutlet weak var tripPresentationControl: TripPresentationControl!
    
    var trip: Trip? {
        didSet {
//            self.tripPresentationControl.trip = trip
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
