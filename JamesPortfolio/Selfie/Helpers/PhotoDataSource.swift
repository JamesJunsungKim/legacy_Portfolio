//
//  PhotoDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import CoreData

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    private let collectionView: UICollectionView
    private let fetchedResultsController: PhotoFetchedResultController
    
    init(fetchRequest: NSFetchRequest<Photo>,managedObjectContext context: NSManagedObjectContext, collectionView: UICollectionView){
        self.collectionView = collectionView
        self.fetchedResultsController = PhotoFetchedResultController(request: fetchRequest, context: context)
        super.init()
        self.fetchedResultsController.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.photoImageView.image = photo.image
        return cell
    }
    
    // MARK: - Helper
    var photos: [Photo] {
        guard let objects = fetchedResultsController.sections?.first?.objects as? [Photo] else {return []}
        return objects
    }
    
}


extension PhotoDataSource : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}










