//
//  PhotoPageController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class PhotoPageController: UIPageViewController {
    
    var photos: [Photo] = []
    var indexOfCurrentPhoto: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setupViewController()
        
        
    }
    
    func setupViewController() {
        if let photoViwerController = photoViewerController(with: photos[indexOfCurrentPhoto]) {
            setViewControllers([photoViwerController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func photoViewerController(with photo: Photo)-> PhotoViewerController? {
        guard let storyboard = storyboard, let photoViewerController = storyboard.instantiateViewController(withIdentifier: PhotoViewerController.reuseIdentifier) as? PhotoViewerController else {return nil}
        
        guard let index = photos.index(of: photo) else {return nil}
        
        photoViewerController.photo = photo
        photoViewerController.pageIndex = index
        photoViewerController.delegate = self
        return photoViewerController
    }
    
    
}

extension PhotoPageController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoVC = viewController as? PhotoViewerController, let index = photos.index(of: photoVC.photo) else {return nil}
        
        if index == photos.startIndex {
            return nil
        } else {
            let indexBefore = photos.index(before: index)
            let photo = photos[indexBefore]
            return photoViewerController(with: photo)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoVC = viewController as? PhotoViewerController, let index = photos.index(of: photoVC.photo) else {return nil}
        
        if index == photos.index(before: photos.endIndex) {
            return nil
        } else {
            let indexAfter = photos.index(after: index)
            let photo = photos[indexAfter]
            return photoViewerController(with: photo)
        }
    }
    
    
}

extension PhotoPageController : PhotoIndexHelperDelegate {
    func showIndex(index: Int) {
        self.title = "\(index+1) out of \(photos.count)"
    }
}


















