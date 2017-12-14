//
//  PhotoFilters.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/13/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import CoreImage

struct PhotoFilter {
    private struct Filters {
        static let colorClamp = "CIColorClamp"
        static let colorControls = "CIColorControls"
        static let instantPhoto = "CIPhotoEffectInstant"
        static let effectPhoto = "CIPhotoEffectProcess"
        static let noirPhoto = "CIPhotoEffectNoir"
        static let sepia = "CISepiaTone"
    }
    
    private struct Constants {
        static let inputMinComponents = "inputMinComponents"
        static let inputMaxComponents = "inputMaxComponents"
        static let inputSaturation = kCIInputSaturationKey
        static let inputIntensity = kCIInputIntensityKey
    }
    
    private static var colorClamp: CIFilter {
        let colorClamp = CIFilter(name: Filters.colorClamp)!
        let minVector = CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2)
        colorClamp.setValue(minVector, forKey: Constants.inputMinComponents)
        
        let maxVector = CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9)
        colorClamp.setValue(maxVector, forKey: Constants.inputMaxComponents)
        
        return colorClamp
    }
    
    private static var colorControls: CIFilter {
        let colorControls = CIFilter(name: Filters.colorControls)!
        colorControls.setValue(0.1, forKey: Constants.inputSaturation)
        return colorControls
    }
    
    private static var sepia: CIFilter {
        let sepia = CIFilter(name: Filters.sepia)!
        sepia.setValue(0.7, forKey: Constants.inputIntensity)
        return sepia
    }
    
    static var defaultFilters: [CIFilter] {
        let instantPhoto = CIFilter(name: Filters.instantPhoto)!
        let effectPhoto = CIFilter(name: Filters.effectPhoto)!
        let noirPhoto = CIFilter(name: Filters.noirPhoto)!
        return [colorClamp, colorControls, instantPhoto, effectPhoto, noirPhoto, sepia]
    }
    
    static var filterNames : [String] {
        return ["Clamp", "Controls", "Instant", "Effect", "Noir", "Sepia"]
    }
    
}












