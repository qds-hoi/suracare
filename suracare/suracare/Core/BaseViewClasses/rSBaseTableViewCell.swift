//
//  rSBaseTableViewCell.swift
//  suracare
//
//  Created by hoi on 7/22/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit

class rSBaseTableViewCell: UITableViewCell {

    class var reuseId: String {
        return String.className(self)
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
