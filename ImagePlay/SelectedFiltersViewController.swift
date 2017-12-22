//
//  SelectedFiltersViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/20/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class SelectedFiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var filtersTable: UITableView!
    @IBOutlet weak var noFilterView: UIView!
    var currentImage: UIImage? {
        didSet{
            selectImageForPreview(original: currentImage!)
        }
    }
    private var imageThumbnail: UIImage?
    private var filteredImageCache = [Image]()
    

    @IBAction func onTrashCurrentFilters(_ sender: UIBarButtonItem) {
        currentFilters = []
        handleFiltersChanged()
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        let filter = currentFilters[sender.tag]
        let imageShrinker = ImageResizer(maxDimension: 640)
        let previewImage = imageShrinker.resizeImage(original: currentImage!)
        let filteredPreview = filter.apply(input: Image(image: previewImage))
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "LinearAdjustableViewController")
            as? LinearAdjustmentViewController
        {
            viewController.filter = filter as? LinearAdjustableFilter
            viewController.previewImage = filteredPreview.toUIImage()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTable.isEditing = true
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("FilterUpdate"),
            object: nil,
            queue: OperationQueue.main,
            using: filterUpdate(notification: )
        )
        handleFiltersChanged()
    }
    
    func filterUpdate(notification: Notification) {
        handleFiltersChanged()
    }
    
    func handleFiltersChanged() {
        NotificationCenter.default.post(name: NSNotification.Name("FiltersChanged"), object: nil)
        filtersTable.reloadData()
        if (currentFilters.count == 0) {
            filtersTable.backgroundView = noFilterView
            filtersTable.backgroundView?.isHidden = false
        } else {
            filtersTable.backgroundView?.isHidden = true
        }
        filteredImageCache = []
    }
    
    func selectImageForPreview(original: UIImage ){
        let imageShrinker = ImageResizer(maxDimension: 128)
        imageThumbnail = imageShrinker.resizeImage(original: original)
    }
    
    /* Data Source Methods */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? CustomFilterCell {
            let filter = currentFilters[indexPath.row]
            cell.updateFor(filter: filter, tag: indexPath.row)
            
            if imageThumbnail != nil {
                cell.previewImage.image = getFilteredImageForRow(row: indexPath.row).toUIImage()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            return cell
        }        
    }
    
    private func getFilteredImageForRow (row: Int) -> Image {
        if row < 0 { return Image(image: imageThumbnail!) }
        if row < filteredImageCache.count {
            return filteredImageCache[row]
        } else {
            let filter = currentFilters[row]
            let previousImage = getFilteredImageForRow(row: row-1)
            let filteredImage = filter.apply(input: previousImage)
            filteredImageCache.append(filteredImage)
            return filteredImage
        }
    }
    
    /* Delegate Methods */
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            currentFilters.remove(at: indexPath.row)
            handleFiltersChanged()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = currentFilters[ sourceIndexPath.row ]
        currentFilters.remove(at: sourceIndexPath.row)
        currentFilters.insert(item, at: destinationIndexPath.row)
        handleFiltersChanged()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    /* Navigation */
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addFiltersVC = segue.destination as? AddFilterViewController {
            // addFiltersVC.filtersModel = filtersModel
        }
    }
  */
    
}





















