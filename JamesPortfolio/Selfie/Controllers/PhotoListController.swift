//
//  ViewController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import CoreData

class PhotoListController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let context = CoreDataStack().managedObjectContext
    
    lazy var dataSource: PhotoDataSource = {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        return PhotoDataSource(fetchRequest: request, managedObjectContext: context, collectionView: collectionView)
    }()
    
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        
    }
    
    @IBAction func launchCamera(_ sender: Any) {
        photoPickerManager.presentPhotoPicker(animated: true)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell), let pageViewController = segue.destination as? PhotoPageController {
                
                pageViewController.photos = dataSource.photos
                pageViewController.indexOfCurrentPhoto = indexPath.row
                
            }
        }
    }
}

//MARK: - PhotoPicker Delegate
extension PhotoListController: PhotoPickerManagerDelegate {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        manager.dismissPhotoPicker(animated: true) {
            guard let photoFilterController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PhotoFilterController.self)) as? PhotoFilterController else {
                return
            }
            photoFilterController.photo = image
            photoFilterController.managedObjectContext = self.context
            
            let navController = UINavigationController(rootViewController: photoFilterController)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
}












