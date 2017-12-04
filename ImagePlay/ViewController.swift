//
//  ViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/17/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var swapImageButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var transitionImageView: UIImageView!
    @IBOutlet weak var busySpinner: UIActivityIndicatorView!
   
    var originalImage = UIImage(named: "WinterBlue1000.jpg")!
    var selectedFilters = FiltersModel()
    var isFilteredShowing = false
    let imageShrinker = ImageResizer(maxDimension: 1024)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FiltersChanged"),
            object: nil,
            queue: OperationQueue.main,
            using: filtersChanged(notification: )
        )        
        showOriginalImage()
    }
    
    // ScrollViewDelegate method
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func updateImage(image: UIImage) {
        transitionImageView.alpha = 0
        transitionImageView.image = image
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
        updateImage(image: originalImage )
        swapImageButton.title = (selectedFilters.filters.count > 0) ? ">Filtered" : ""
        navigationItem.title = "Original"
        isFilteredShowing = false
    }

    var filtersHaveChanged = false
    func filtersChanged(notification: Notification) {
        filtersHaveChanged = true
    }
    
   
    @IBAction func onCameraClick(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(sourceType: .camera )
        }))
        ac.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (action) in
            self.showPicker(sourceType: .photoLibrary )
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func showPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picPick = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage = imageShrinker.resizeImage(original: picPick)
            showOriginalImage()
        }
        dismiss(animated: true, completion: nil)
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
            var image = Image(image: self.originalImage)
            
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

