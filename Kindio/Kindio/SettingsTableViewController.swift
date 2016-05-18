//
//  SettingsTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let cellIdentifier = "settingsCellIdentifier"
    var playSession : PlaySession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blueCharcoal()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        
        cell.contentView.backgroundColor = UIColor.blueCharcoal()
        cell.backgroundColor = UIColor.blueCharcoal()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        if (indexPath.section == 0) {
            cell.textLabel?.text = "Last.fm"
            let image = UIImage.init(imageLiteral: "lastFM")
            cell.imageView?.image = image
        } else if (indexPath.section == 1) {
            cell.textLabel?.text = "Equalizer"
            let image = UIImage.init(imageLiteral: "preferencesIcon")
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Accounts"
        } else {
            return "Equalizer"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 0) {
            let lastfmVC = LastfmLoginViewController()
            self.navigationController?.pushViewController(lastfmVC, animated: true)
        } else if (indexPath.section == 1) {
            let presetsVC = EqualizerTableViewController()
            
            if let session = self.playSession {
                presetsVC.presetsArray = session.mediaPlayer.equalizerPresets()
                presetsVC.playSession = self.playSession
            }
            
            self.navigationController?.pushViewController(presetsVC, animated: true)
        }
    }
}
