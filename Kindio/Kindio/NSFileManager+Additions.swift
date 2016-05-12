//
//  NSFileManager+Additions.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

extension NSFileManager  {
     static func applicationDocumentsDirectory() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        return urls[urls.count-1]
    }
}
