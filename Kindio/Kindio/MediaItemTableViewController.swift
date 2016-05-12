//
//  MediaItemTableViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/4/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaItemTableViewController: UITableViewController, ViewControllerAudioProtocol {
    var query : MPMediaQuery! {
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
    
    func onNowPlaying() {
        self.showCurrentlyPlaying()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
