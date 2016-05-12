//
//  TracksTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class TracksTableViewController: MediaItemTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! AudioAssetCell
        
        let currLoc = self.query.itemSections![indexPath.section].range.location
        let mediaItem = self.query.items![indexPath.row + currLoc]
        cell.assetTitleLabel.text = mediaItem.title
        cell.assetSubtitleLabel.text = mediaItem.artist
        cell.extraLabel.text = mediaItem.albumTitle
        
        if let artwork = mediaItem.valueForProperty(MPMediaItemPropertyArtwork) {
            cell.assetImageView.image = artwork.imageWithSize(CGSizeMake(70.0, 70.0))
        } else {
            cell.assetImageView.image = UIImage.init(imageLiteral: "headphones")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let currLoc = self.query.collectionSections![indexPath.section].range.location
        let mediaItem = self.query.items![indexPath.row + currLoc]
        let collection = MPMediaItemCollection.init(items: self.playSession.musicCollectionManager.tracks!)
        
        self.playItem(mediaItem, collection: collection)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = query.itemSections?.count {
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
        let sectionIndexTitles = self.query.itemSections!.map { $0.title }
        
        return sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = query.itemSections?[section] {
            return section.title
        }
        
        return nil
    }
    
}
