//
//  PhotoViewerController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

protocol PhotoIndexHelperDelegate {
    func showIndex(index: Int)
}

class PhotoViewerController: UIViewController {
    
    static let reuseIdentifier = String(describing: PhotoViewerController.self)
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photo: Photo!
    var pageIndex: Int!
    var delegate : PhotoIndexHelperDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = photo.image
    }
    
    @IBAction func launchPhotoZoomController(_ sender: Any) {
        guard let storyboard = storyboard else { return }
        
        let zoomController = storyboard.instantiateViewController(withIdentifier: "PhotoZoomController") as! PhotoZoomController
        zoomController.modalTransitionStyle = .crossDissolve
        zoomController.photo = photo
        
        navigationController?.present(zoomController, animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.showIndex(index: self.pageIndex)
    }
    
}




















