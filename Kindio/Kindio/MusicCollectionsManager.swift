//
//  MusicCollectionsManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicCollectionsManager: NSObject {
    
    lazy var tracksQuery : MPMediaQuery = {
        let query = MPMediaQuery.songsQuery()
        query.groupingType = .Title
        
        return query
    }()
    
    lazy var artistsQuery : MPMediaQuery = {
        let query = MPMediaQuery.artistsQuery()
        query.groupingType = .Artist
        
        return query
    }()
    
    lazy var albumsQuery : MPMediaQuery = {
        let query = MPMediaQuery.albumsQuery()
        query.groupingType = .Album
        
        return query
    }()
    
    lazy var tracks : [MPMediaItem]? = {
        let query = self.tracksQuery
        
        if let musicTracks = query.items {
            return musicTracks
        }
        
        return nil
    }()
    
    lazy var artists : [MPMediaItem]? = {
       let query = self.artistsQuery
        
        if let allArtists = query.items {
            return allArtists
        }
        
        return nil
    }()
 
    lazy var albums : [MPMediaItem]? = {
        let query = self.albumsQuery
        
        if let allAlbums = query.items {
            return allAlbums
        }
        
        return nil
    }()
    
}
