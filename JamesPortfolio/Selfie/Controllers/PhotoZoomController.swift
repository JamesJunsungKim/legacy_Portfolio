//
//  PhotoZoomController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/12/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class PhotoZoomController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    var photo : Photo!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        photoImageView.image = photo.image
        scrollView.delegate = self
        
        photoImageView.sizeToFit()
        scrollView.contentSize = photoImageView.bounds.size
        updateZoomScale()
        updateConstraintForSize(view.bounds.size)
    }
    
    
    var minZoomScale: CGFloat {
        let viewSize = view.bounds.size
        
        let widthScale = viewSize.width/photoImageView.bounds.width
        let heightScale = viewSize.height/photoImageView.bounds.height
        
        return min(widthScale, heightScale)
    }
    
    func updateZoomScale() {
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
    }
    
    func updateConstraintForSize(_ size: CGSize) {
        let verticalSpace = size.height - photoImageView.frame.height
        let yOfsset = max(verticalSpace/2, 0)
        
        imageViewTopConstraint.constant = yOfsset
        imageViewBottomConstraint.constant = yOfsset
        
        let xOffset = max(0, (size.width - photoImageView.frame.width))
        
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
    }
    @IBAction func imageTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoZoomController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintForSize(view.bounds.size)
        
        if scrollView.zoomScale < minZoomScale {
            photoImageView.isUserInteractionEnabled = true
        }
    }
    
}













