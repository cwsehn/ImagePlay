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
    
    var filtersModel = FiltersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTable.isEditing = true
    }
    
    
    /* Data Source Methods */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersModel.filters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = filtersModel.filters[indexPath.row].name
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
            filtersModel.filters.remove(at: indexPath.row)
            filtersTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = filtersModel.filters[ sourceIndexPath.row ]
        filtersModel.filters.remove(at: sourceIndexPath.row)
        filtersModel.filters.insert(item, at: destinationIndexPath.row)
        filtersTable.reloadData()
    }
}





















