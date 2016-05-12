//
//  SongsTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/9/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsTableViewController: UITableViewController, ViewControllerAudioProtocol {
    
    var songs : [MPMediaItem]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var playSession : PlaySession!
    internal let cellIdentifier = "mediaItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blueCharcoal()
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        self.tableView.sectionIndexColor = UIColor.redLust()
        
        let nib = UINib.init(nibName: "AudioAssetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90.0
        
        let nowPlayingImage = UIImage.init(imageLiteral:"audioWave")
        let nowPlayingButton = UIBarButtonItem.init(image: nowPlayingImage, style: .Plain, target: self, action: #selector(TracksTableViewController.onNowPlaying))
        self.navigationItem.rightBarButtonItem = nowPlayingButton
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allSongs = self.songs {
            return allSongs.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! AudioAssetCell
        
        let mediaItem = self.songs![indexPath.row]
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mediaItem = self.songs![indexPath.row]
        let collection = MPMediaItemCollection.init(items: self.playSession.musicCollectionManager.tracks!)
        
        self.playItem(mediaItem, collection: collection)
    }

    func onNowPlaying() {
        self.showCurrentlyPlaying()
    }
    
    func playItem(mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        if let tbc = self.tabBarController as? KDTabBarController {
            tbc.playItem(mediaItem, collection: collection)
        }
    }
    
    func showCurrentlyPlaying() {
        if let tbc = self.tabBarController as? KDTabBarController {
            tbc.showAudioPlayer()
        }
    }

}
