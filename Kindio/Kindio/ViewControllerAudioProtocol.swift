//
//  ViewControllerAudioProtocol.swift
//  Kindio
//
//  Created by Alin Petrus on 5/6/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation
import MediaPlayer

protocol ViewControllerAudioProtocol {
    func playItem(mediaItem: MPMediaItem, collection: MPMediaItemCollection)
    func showCurrentlyPlaying()
}