//
//  String+Duration.swift
//  Kindio
//
//  Created by Alin Petrus on 5/5/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

extension String {
    static func formatedDuration(duration : Double) -> String {
        let hours = Int(duration / 3600)
        let minutes = Int(duration / 60)
        let seconds = Int(duration % 60)
        
        let hoursString = hours < 10 ? String(format: "%02d", hours) : "\(hours)"
        let minutesString = minutes < 10 ? String(format: "%02d", minutes) : "\(minutes)"
        let secondsString = seconds < 10 ? String(format: "%02d", seconds) : "\(seconds)"
        
        if (Int(hours) > 0) {
            return "\(hoursString):\(minutesString):\(secondsString)"
        } else {
            return "\(minutesString):\(secondsString)"
        }
    }
}
