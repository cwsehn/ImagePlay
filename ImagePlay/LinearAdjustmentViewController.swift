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
    var previewImageView = UIImageView()
    
    var previewImage: UIImage? {
        get {
            return previewImageView.image
        }
        set {
            previewImageView.image = newValue
            previewImageView.sizeToFit()
            scrollView?.contentSize = previewImageView.frame.size
        }
    }
    var imageB4Edit: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
            scrollView.contentSize = previewImageView.frame.size
            scrollView.addSubview(previewImageView)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderChanged(_ sender: UISlider) {
        filter?.value = Double(slider.value)
        applyFilterToPreview()
        NotificationCenter.default.post(name: NSNotification.Name("FilterUpdate"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = filter?.name
        slider.minimumValue = Float((filter?.min)!)
        slider.maximumValue = Float((filter?.max)!)
        slider.value = Float((filter?.value)!)
        imageB4Edit = previewImage
    }
    
    private func applyFilterToPreview() {
        if previewImage != nil {
            let filteredPreview = filter?.apply(input: Image(image: imageB4Edit!))
            previewImage = filteredPreview?.toUIImage()
        }
    }
}


extension LinearAdjustmentViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }
}
