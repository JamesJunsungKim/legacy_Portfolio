//
//  ImageFiltrationOperation.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/13/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import CoreImage

enum ImageFilterState {
    case noFilter, filtered
}

class FiltrationImage {
    var image: UIImage
    var filterState: ImageFilterState = .noFilter
    
    init(image: UIImage) {
        self.image = image
    }
}

class ImageFiltrationOperation: Operation {
    let filtrationImage: FiltrationImage
    let filter: CIFilter
    
    init(image: FiltrationImage, filter: CIFilter) {
        self.filtrationImage = image
        self.filter = filter
    }
    
    override func main () {
        if self.isCancelled {
            return
        }
        
        if self.filtrationImage.filterState == .filtered {
            return
        }
        
        if let filteredImage = applyFilter(filter, to: filtrationImage.image) {
            filtrationImage.image = filteredImage
            filtrationImage.filterState = .filtered
        }
    }
    
    func applyFilter(_ filter: CIFilter, to image: UIImage) -> UIImage? {
        let filteredImageBuilder = FilteredImageBuilder(image: image)
        if let filteredImage = filteredImageBuilder.applyFilter(filter) {
            let outputImage = UIImage(ciImage: filteredImage)
            let rect = CGRect(origin: .zero, size: filtrationImage.image.size)
            
            UIGraphicsBeginImageContext(filtrationImage.image.size)
            outputImage.draw(in: rect)
            guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            
            return scaledImage
        } else {
            return nil
        }
    }
}

