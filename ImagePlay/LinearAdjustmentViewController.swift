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
        
    @IBAction func sliderChanged(_ sender: UISlider) {
        filter?.value = Double(slider.value)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = filter?.name
        slider.minimumValue = Float((filter?.min)!)
        slider.maximumValue = Float((filter?.max)!)
        slider.value = Float((filter?.value)!)
    }
}
