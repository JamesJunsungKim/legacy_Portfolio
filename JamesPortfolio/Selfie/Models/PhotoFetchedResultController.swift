//
//  PhotoFetchedResultController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//
import UIKit
import CoreData

class PhotoFetchedResultController: NSFetchedResultsController<Photo> {
    
    init(request: NSFetchRequest<Photo>, context: NSManagedObjectContext) {
        
        super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetch()
    }
    
    func fetch() {
        do {
            try performFetch()
        } catch {
            fatalError("failed to fetch from fetchedController")
        }
    }
    
    

}











