//
//  Dictionary+Utils.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
