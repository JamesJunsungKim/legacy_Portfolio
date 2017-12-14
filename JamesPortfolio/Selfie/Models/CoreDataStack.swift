//
//  CoreDataStack.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import CoreData
import UIKit

class CoreDataStack: NSObject {
    
    private lazy var persistentContainer : NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Selfie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unable to get the persistent container ")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let container = persistentContainer
        return container.viewContext
    }()

    
}

extension NSManagedObjectContext {
    func saveChange() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
