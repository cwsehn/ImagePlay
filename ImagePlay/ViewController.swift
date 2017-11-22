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
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FiltersChanged"),
            object: nil, queue: OperationQueue.main,
            using: filtersChanged(notification: ))
        
        imageView.image = filterImage().toUIImage()
    }

    var filtersHaveChanged = false
    func filtersChanged(notification: Notification) {
        filtersHaveChanged = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( filtersHaveChanged) {
            imageView.image = filterImage().toUIImage()
            filtersHaveChanged = false
        }
        
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

