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
    var selectedFilters = FiltersModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFilters.filters.append( MixFilter() )
        selectedFilters.filters.append( ScaleIntensityFilter(scale: 0.9) )
        imageView.image = filterImage().toUIImage()
    }

    func filterImage() -> Image {
       var image = Image(image: UIImage(named: "WinterBlue2.jpg")!)
        
        for filter in selectedFilters.filters {
            image = filter.apply(input: image)
        }
        return image
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectFiltersViewController = segue.destination as? SelectedFiltersViewController {
            selectFiltersViewController.filtersModel = selectedFilters
        }
    }
}

