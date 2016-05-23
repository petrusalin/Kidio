//
//  CoreDataManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    var databaseName: String!
    
    override init() {
        databaseName = "KindioCoreData.sqlite"
    }
    
    init(databaseName: String) {
        self.databaseName = databaseName
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Kindio", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = NSFileManager.applicationDocumentsDirectory().URLByAppendingPathComponent(self.databaseName)
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func storedEqualizer() -> SixBandEqualizerContainer? {
        let request = NSFetchRequest.init(entityName: "SixBandEqualizerContainer")
        
        do {
            let eqs = try self.managedObjectContext.executeFetchRequest(request) as! [SixBandEqualizerContainer]
            
            return eqs.first
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return nil
    }
    
    func saveEqualizerSettings(equalizer: SixBandEqualizer) {
        let mutableSet = NSMutableSet()
        
        var eqContainer = self.storedEqualizer()
        
        if eqContainer == nil {
            eqContainer = (NSEntityDescription.insertNewObjectForEntityForName("SixBandEqualizerContainer", inManagedObjectContext: self.managedObjectContext) as! SixBandEqualizerContainer)
        }
        
        for amp in equalizer.amplifications() {
            if let bandAmp = NSEntityDescription.insertNewObjectForEntityForName("EQAmplificationContainer", inManagedObjectContext: self.managedObjectContext) as? EQAmplificationContainer {
                bandAmp.gain = NSNumber(float: amp.gain)
                bandAmp.band = amp.band.rawValue
                mutableSet.addObject(bandAmp)
            }
        }
        
        eqContainer!.bandAmplifications = mutableSet
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Could not save eq settings")
        }
    }
    
    func equalizerSettings() -> SixBandEqualizer? {
        let eq = SixBandEqualizer()
        
        if let amps = self.storedEqualizer()?.bandAmplifications?.allObjects {
            for amp in amps {
                if let bandAmp = amp as? EQAmplificationContainer {
                    if let band = bandAmp.band, gain = bandAmp.gain {
                        eq.setAmplification(gain.floatValue, band: EqualizerBand(rawValue: Int(band.intValue))!)
                    }
                }
            }
            
            return eq
        }
        
        return nil
    }
    
}
