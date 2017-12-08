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
    
    //var currentFilters = FiltersModel()
    
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
        } else {
            filtersTable.backgroundView = nil
        }
    }
    
    /* Data Source Methods */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFilters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = currentFilters[indexPath.row].name
        cell.showsReorderControl = true
        return cell
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
    
    /* Navigation */
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addFiltersVC = segue.destination as? AddFilterViewController {
            // addFiltersVC.filtersModel = filtersModel
        }
    }
  */
    
}





















