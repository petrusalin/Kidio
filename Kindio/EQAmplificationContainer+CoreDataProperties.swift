//
//  EQAmplificationContainer+CoreDataProperties.swift
//  
//
//  Created by Alin Petrus on 5/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EQAmplificationContainer {

    @NSManaged var gain: NSNumber?
    @NSManaged var band: NSNumber?
    @NSManaged var sixBandEqualizer: SixBandEqualizerContainer?

}
