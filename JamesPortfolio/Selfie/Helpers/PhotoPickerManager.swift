//
//  PhotoPickerManager.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    private let presentingController: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingController = presentingViewController
        super.init()
        
        configure()
    }
    
    func presentPhotoPicker(animated: Bool) {
        presentingController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissPhotoPicker(animated:Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    private func configure() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
    }
    
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let edittedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            delegate?.manager(self, didPickImage: edittedImage)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.manager(self, didPickImage: image)
        } else {
            print("unable to get an image from the image picker")
        }
    }
}





















