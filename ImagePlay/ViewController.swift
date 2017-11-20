//
//  ViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/17/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = Image(image: UIImage(named: "WinterBlue2.jpg")!)
        //let i2 = image.transformPixels(transformFunc: halfIntensity)
        //imageView.image = i2.toUIImage()
        
        let f1 = MixFilter()
        let f2 = ScaleIntensityFilter(scale: 0.9)
        let image2 = f1.apply(input: image)
        let image3 = f2.apply(input: image2)
        imageView.image = image3.toUIImage()
    }

    
    /*
    func halfIntensity(p:RGBAPixel) -> RGBAPixel {
        var p2 = p
        p2.red = p2.red/2
        p2.green = p2.green/2
        p2.blue = p2.blue/2
        return p2
    }
    */

}

