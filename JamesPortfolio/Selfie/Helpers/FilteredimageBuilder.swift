//
//  FilteredimageBuilder.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/13/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import CoreImage

final class FilteredImageBuilder {
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyFilter(_ filter: CIFilter) -> CIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: self.image) else {return nil}
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else {return nil}
        
        return outputImage.cropped(to: inputImage.extent)
    }
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.flatMap{applyFilter($0)}
    }
    
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters)
    }
    
}
