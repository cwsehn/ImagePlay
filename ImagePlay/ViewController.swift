//
//  ViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/17/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var swapImageButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var transitionImageView: UIImageView!
    var selectedFilters = FiltersModel()
    var isFilteredShowing = false
    
    @IBOutlet weak var busySpinner: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FiltersChanged"),
            object: nil, queue: OperationQueue.main,
            using: filtersChanged(notification: )
        )        
        showOriginalImage()
    }
    
    func updateImage(image: UIImage) {
        self.transitionImageView.alpha = 0
        self.transitionImageView.image = image
        UIView.animate(
            withDuration: 0.7,
            animations: {
                self.transitionImageView.alpha = 1
            },
            completion: { (finished) in
                self.imageView.image = image
                self.transitionImageView.alpha = 0
            }
        )
    }
    
    func showOriginalImage() {
        updateImage(image: UIImage(named: "WinterBlue1000.jpg")! )
        swapImageButton.title = ">Filtered"
        navigationItem.title = "Original"
        isFilteredShowing = false
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
                self.updateImage(image: image.toUIImage())
                self.swapImageButton.title = ">Original"
                self.navigationItem.title = "Filtered"
                self.isFilteredShowing = true
            }
        }
    }

    @IBAction func swapImage(_ sender: UIBarButtonItem) {
        if (isFilteredShowing) {
            showOriginalImage()
        } else {
            applyFilterAndShow()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectFiltersViewController = segue.destination as? SelectedFiltersViewController {
            selectFiltersViewController.filtersModel = selectedFilters
        }
    }
}

