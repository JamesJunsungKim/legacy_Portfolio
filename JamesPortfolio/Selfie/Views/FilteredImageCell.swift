//
//  FilteredImageCell.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/13/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import GLKit

final class FilteredImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: FilteredImageCell.self)
    
    var eaglContext: EAGLContext!
    
    lazy var context: CIContext = {
        return CIContext(eaglContext: self.eaglContext)
    }()
    
    var image: CIImage!
    
    let filterNameLabel : UILabel = {
        let filterLabel = UILabel()
        filterLabel.textAlignment = .center
        return filterLabel
    }()
    
    lazy var glkView: GLKView = {
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(glkView)
        contentView.addSubview(filterNameLabel)
        
        _ = filterNameLabel.anchor(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = glkView.anchor(top: filterNameLabel.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, topConstant: 10, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
}

extension FilteredImageCell: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        let drawableRectSize = CGSize(width: view.drawableWidth, height: view.drawableHeight)
        let drawableRect = CGRect(origin: .zero, size: drawableRectSize)
        context.draw(image, in: drawableRect, from: image.extent)
    }
}
