//
//  KDTabBarController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class KDTabBarController: UITabBarController {
    let playSession = PlaySession()
    private var audioPlayerViewController : CurrentlyPlayingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioPlayerViewController = CurrentlyPlayingViewController()
        self.onTracksSelected()
    }
    
    func playItem(mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        self.showAudioPlayer()
        
        self.audioPlayerViewController.startWithPlaySession(self.playSession, mediaItem: mediaItem, collection: collection)
    }
    
    func showAudioPlayer() {
        if let navController = self.selectedViewController as? UINavigationController {
            navController.pushViewController(self.audioPlayerViewController, animated: true)
        }
    }
    
    func trackTableViewController() -> TracksTableViewController {
        let navController = self.viewControllers![0] as! UINavigationController
        
        return navController.viewControllers[0] as! TracksTableViewController
    }
    
    func artistsTableViewController() -> ArtistsTableViewController {
        let navController = self.viewControllers![1] as! UINavigationController
        
        return navController.viewControllers[0] as! ArtistsTableViewController
    }
    
    func albumsTableViewController() -> AlbumsTableViewController {
        let navController = self.viewControllers![2] as! UINavigationController
        
        return navController.viewControllers[0] as! AlbumsTableViewController
    }
    
    func settingsTableViewController() -> SettingsTableViewController {
        let navController = self.viewControllers![3] as! UINavigationController
        
        return navController.viewControllers[0] as! SettingsTableViewController
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let index = tabBar.items?.indexOf(item) {
            switch index {
            case 0:
                self.onTracksSelected()
            case 1:
                self.onArtistsSelected()
            case 2:
                self.onAlbumsSelected()
            case 3:
                self.onSettingsSelected()
            default:
                break;
            }
        }
    }
    
    private func onTracksSelected() {
        self.trackTableViewController().playSession = self.playSession
        self.trackTableViewController().query = self.playSession.musicCollectionManager.tracksQuery
    }
    
    private func onArtistsSelected() {
        self.artistsTableViewController().playSession = self.playSession
        self.artistsTableViewController().query = self.playSession.musicCollectionManager.artistsQuery
    }
    
    private func onAlbumsSelected() {
        self.albumsTableViewController().playSession = self.playSession
        self.albumsTableViewController().query = self.playSession.musicCollectionManager.albumsQuery
    }
    
    private func onSettingsSelected() {
        self.settingsTableViewController().playSession = self.playSession
    }
}
