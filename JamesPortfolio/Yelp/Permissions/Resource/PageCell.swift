//
//  PageCell.swift
//  PracticeOauth
//
//  Created by James Kim on 12/4/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet{
            guard let page = page else {return}
            configure(with: page)
        }
    }
    
    // MARK: - UI
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "page1")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample text goes here"
        textView.isEditable = false
        return textView
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
        
        _ = imageView.anchor(top: topAnchor, right: rightAnchor, bottom: textView.topAnchor, left: leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = textView.anchor(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, topConstant: 0, rightConstant: 16, bottomConstant: 0, leftConstant: 16, widthConstant: 0, heightConstant: 0)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        _ = lineSeparatorView.anchor(top: nil, right: rightAnchor, bottom: textView.topAnchor, left: leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    func configure(with page: Page) {
        imageView.image = UIImage(named: page.imageName)
        
        let color = UIColor(white: 0.2, alpha:1)
        let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : color])
        
        attributedText.append(NSMutableAttributedString(string: "\n\n\(page.description)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: color]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let length = attributedText.string.count
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: length))
        
        textView.attributedText = attributedText
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












