//
//  BaseTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 45
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.backgroundColor = UIColor.blueCharcoal()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
