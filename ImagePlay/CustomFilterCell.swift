//
//  CustomFilterCell.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 12/13/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class CustomFilterCell: UITableViewCell {


    @IBOutlet weak var customLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    func updateFor(filter: Filter, tag: Int) {
        self.customLabel.text = filter.name
        if filter is LinearAdjustableFilter {
            self.editButton.isHidden = false
        } else {
            self.editButton.isHidden = true
        }
        self.showsReorderControl = true
        self.tag = tag
    }
    
    


}

