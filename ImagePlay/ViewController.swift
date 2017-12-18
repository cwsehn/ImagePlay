//
//  ViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/17/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var swapImageButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var transitionImageView: UIImageView!
    @IBOutlet weak var busySpinner: UIActivityIndicatorView!
    @IBOutlet weak var imagePickerButton: UIBarButtonItem!
    
    
    var originalImage = UIImage(named: "WinterBlue1000.jpg")!
    //var selectedFilters = currentFilters
    var isFilteredShowing = false
    let imageShrinker = ImageResizer(maxDimension: 1024)
    
    let picker = UIImagePickerController()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        scrollView.delegate = self
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FiltersChanged"),
            object: nil,
            queue: OperationQueue.main,
            using: filtersChanged(notification: )
        )
        checkPermission()
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
        swapImageButton.title = (currentFilters.count > 0) ? ">Filtered" : ""
        navigationItem.title = "Original"
        isFilteredShowing = false
    }

    var filtersHaveChanged = false
    func filtersChanged(notification: Notification) {
        filtersHaveChanged = true
    }
    
   
    @IBAction func onCameraClick(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [unowned self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showPicker(sourceType: .camera )
            }
        }))
        ac.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { [unowned self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.showPicker(sourceType: .photoLibrary )
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        ac.modalPresentationStyle = .popover
        self.present(ac, animated: true, completion: nil)
        ac.popoverPresentationController?.barButtonItem = sender
    }
    
    func showPicker(sourceType: UIImagePickerControllerSourceType) {
        self.picker.allowsEditing = false
        self.picker.sourceType = sourceType
        if sourceType == .camera {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                //let photoURL =
                present(self.picker, animated: true, completion: nil)
                picker.takePicture()
                
                
            }
        } else {
            self.picker.modalPresentationStyle = .popover
            present(self.picker, animated: true, completion: nil)
            self.picker.popoverPresentationController?.barButtonItem = self.imagePickerButton
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let picPick = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage = imageShrinker.resizeImage(original: picPick)
            showOriginalImage()
        } else {
            if let picPick = info[UIImagePickerControllerImageURL] as? URL {
                fetchImage(url: picPick)
            }
        }
        
        dismiss(animated: true, completion: nil)
        /*================================================*/
        //info[keys] for UIImagePicker info Dictionary
        //     UIImagePickerControllerImageURL
        //     UIImagePickerControllerOriginalImage
        //     UIImagePickerControllerEditedImage
        /*================================================*/
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("did show")
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( filtersHaveChanged) {
            applyFilterAndShow()
            filtersHaveChanged = false
        }
    }
    
    private func fetchImage (url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                if let selectedImage = UIImage(data: imageData) {
                    let shrunkenPic = self?.imageShrinker.resizeImage(original: selectedImage)
                    self?.originalImage = shrunkenPic ?? UIImage(named: "WinterBlue1000.jpg")!
                }
                DispatchQueue.main.async {
                    self?.showOriginalImage()
                }
            }
        }
    }
    
    
    func applyFilterAndShow() {
        busySpinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            var image = Image(image: self.originalImage)
            
            for filter in currentFilters {
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
    
    @IBAction func onShare(_ sender: UIBarButtonItem) {
        let vc = UIActivityViewController(activityItems: [self.imageView.image!], applicationActivities: nil)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.barButtonItem = sender
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectFiltersViewController = segue.destination as? SelectedFiltersViewController {
            selectFiltersViewController.selectImageForPreview(original: originalImage)
        }
    }
 
    
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

