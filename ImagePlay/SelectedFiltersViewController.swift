//
//  SelectedFiltersViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/20/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class SelectedFiltersViewController: UIViewController, UITableViewDataSource {


    @IBOutlet weak var filtersTable: UITableView!
    
    var filtersModel = FiltersModel()
    
    
    /* Data Source Methods */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersModel.filters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = filtersModel.filters[indexPath.row].name
        return cell
    }
 

}
