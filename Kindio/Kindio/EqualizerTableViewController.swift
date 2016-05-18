//
//  EqualizerTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/17/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class EqualizerTableViewController: UITableViewController {
    var playSession : PlaySession?
    
    var presetsArray : [String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let cellIdentifier = "cellIdentifier"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 45
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presets = presetsArray {
            return presets.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.presetsArray![indexPath.row]
        cell.contentView.backgroundColor = UIColor.blueCharcoal()
        cell.backgroundColor = UIColor.blueCharcoal()
        cell.textLabel?.textColor = UIColor.whiteColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let session = self.playSession {
            session.mediaPlayer.selectEQPreset(indexPath.row)
        }
    }
    
}
