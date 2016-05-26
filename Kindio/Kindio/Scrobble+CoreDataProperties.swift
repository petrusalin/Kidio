//
//  Scrobble+CoreDataProperties.swift
//  
//
//  Created by Alin Petrus on 5/26/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Scrobble {

    @NSManaged var artist: String?
    @NSManaged var timestamp: NSNumber?
    @NSManaged var title: String?

}
