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
    
    @IBOutlet weak var busySpinner: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FiltersChanged"),
            object: nil, queue: OperationQueue.main,
            using: filtersChanged(notification: )
        )
        
        applyFilterAndShow()
    }

    var filtersHaveChanged = false
    func filtersChanged(notification: Notification) {
        filtersHaveChanged = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( filtersHaveChanged) {
            applyFilterAndShow()
            filtersHaveChanged = false
        }
    }
    
    func applyFilterAndShow() {
        busySpinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            var image = Image(image: UIImage(named: "WinterBlue1000.jpg")!)
            
            for filter in self.selectedFilters.filters {
                image = filter.apply(input: image)
            }
            DispatchQueue.main.async {
                self.busySpinner.stopAnimating()
                self.imageView.image = image.toUIImage()
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectFiltersViewController = segue.destination as? SelectedFiltersViewController {
            selectFiltersViewController.filtersModel = selectedFilters
        }
    }
}

