//
//  LinearAdjustmentViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 12/13/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class LinearAdjustmentViewController: UIViewController {

    var filter: LinearAdjustableFilter?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = filter?.name
    }
}
