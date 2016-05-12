//
//  ArtistsTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistsTableViewController: MediaItemTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! AudioAssetCell
        
        let currLoc = self.query.collectionSections![indexPath.section].range.location
        let mediaItem = self.query.collections![indexPath.row + currLoc]
        cell.assetTitleLabel.text = mediaItem.representativeItem?.artist
        
        if (mediaItem.items.count == 1) {
            cell.assetSubtitleLabel.text = "\(mediaItem.items.count) Song"
        } else {
            cell.assetSubtitleLabel.text = "\(mediaItem.items.count) Songs"
        }
        cell.extraLabel.text = ""
        cell.assetImageView.image = UIImage.init(imageLiteral: "musicConductor")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let currLoc = self.query.collectionSections![indexPath.section].range.location
        let mediaItem = self.query.collections![indexPath.row + currLoc]
        let songsController = SongsTableViewController()
        songsController.playSession = self.playSession
        songsController.songs = mediaItem.items
        
        self.navigationController?.pushViewController(songsController, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = query.collectionSections?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.query.collectionSections![section].range.length
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let sectionIndexTitles = self.query.collectionSections!.map { $0.title }
        
        return sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = query.collectionSections?[section] {
            return section.title
        }
        
        return nil
    }
}
