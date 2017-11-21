//
//  AddFilterViewController.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/21/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class AddFilterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Add Filter", for: indexPath)
        cell.textLabel?.text = allFilters[indexPath.row].name
        return cell
    }


}
