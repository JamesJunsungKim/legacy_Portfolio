//
//  PhotoFilterController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/13/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import CoreData

class PhotoFilterController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    var managedObjectContext: NSManagedObjectContext?
    var photo: UIImage?
    let eaglContext = EAGLContext(api: .openGLES3)!
    var selectedFilter: CIFilter?
    
    let queue = OperationQueue()
    
    let conversionNotificationKey = Notification.Name(rawValue: "conversionIsFinished")
    
    
    lazy var displayPhoto: UIImage? = {
        guard let image = photo else { return nil }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let screenWidth = UIScreen.main.bounds.width
        
        let scaledRatio = screenWidth/imageWidth
        let scaledHeight = scaledRatio * imageHeight
        
        let size = CGSize(width: screenWidth, height: scaledHeight)
        
        return image.resized(to: size)
    }()
    
    private lazy var filteredImages: [CIImage] = {
        guard let image = self.photo else { return [] }
        let filteredImageBuilder = FilteredImageBuilder(image: image)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = displayPhoto
        
        setupCollectionView()
        setupNavigation()
        createObserver()
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveFilteredPhotoandDimsiss), name: conversionNotificationKey, object: nil)
    }
    
    func setupCollectionView() {
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
    }
    
    func setupNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPhotoFilterController))
        let nextButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(startConversion))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func saveFilteredPhotoandDimsiss() {
        let _ = Photo.with(photo!, in: managedObjectContext!)
        managedObjectContext?.saveChange()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func startConversion() {
        applyFilter(scaleFactor: 0.5)
    }
    
    @objc func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
    }
    
    func applyFilter(scaleFactor scale: CGFloat) {
        guard let image = photo, let filter = selectedFilter else {return}
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let size = CGSize(width: imageWidth*scale, height: imageHeight*scale)
        
        guard let resizedImage = image.resized(to: size) else {return}
        let filtrationImage = FiltrationImage(image: resizedImage)
        
        let operation = ImageFiltrationOperation(image: filtrationImage, filter: filter)
        
        operation.completionBlock = {
            if operation.isCancelled {return}
            self.photo = operation.filtrationImage.image
            NotificationCenter.default.post(name: self.conversionNotificationKey, object: nil)
            
        }
        queue.addOperation(operation)
    }
    
}

extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell

        let image = filteredImages[indexPath.row]
        cell.eaglContext = eaglContext
        cell.filterNameLabel.text = PhotoFilter.filterNames[indexPath.row]
        cell.image = image

        return cell
    }
    
}

extension PhotoFilterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = PhotoFilter.defaultFilters[indexPath.row]
        self.selectedFilter = filter
        
        let image = FiltrationImage(image: displayPhoto!)
        let operation = ImageFiltrationOperation(image: image, filter: filter)
        
        operation.completionBlock = {
            if operation.isCancelled { return }
            
            DispatchQueue.main.async {
                self.photoImageView.image = operation.filtrationImage.image
            }
        }
        
        queue.addOperation(operation)
    }
}
