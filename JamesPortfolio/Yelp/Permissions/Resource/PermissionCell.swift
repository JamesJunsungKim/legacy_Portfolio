//
//  PermissionCell.swift
//  PracticeOauth
//
//  Created by James Kim on 12/4/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit


class PermissionCell : UICollectionViewCell {
    
    static let startButtonPressedNotifiationName = NSNotification.Name(rawValue: "startButtonPressed")
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        return button
    }()
    
    let explanationLabel: UILabel = {
        let labelView = UILabel()
        labelView.text = "In order to experince full features in this portfolio, please allow it to use your location"
        labelView.numberOfLines = 0
        labelView.textAlignment = .center
        return labelView
    }()
    
    let separatorLine: UIView = {
       let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return line
    }()
    
    let summaryLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(explanationLabel)
        addSubview(separatorLine)
        addSubview(startButton)
        addSubview(summaryLabel)
        
        _ = explanationLabel.anchor(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, topConstant: 70, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 100)
        _ = separatorLine.anchor(top: explanationLabel.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, topConstant: 10, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = summaryLabel.anchor(top: separatorLine.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, topConstant: 10, rightConstant: 5, bottomConstant: 0, leftConstant: 5, widthConstant: 0, heightConstant: 370)
        _ = startButton.anchor(top: nil, right: nil, bottom: bottomAnchor, left: nil, topConstant: 0, rightConstant: 0, bottomConstant: 50, leftConstant: 0, widthConstant: 150, heightConstant: 50)
        startButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        setupText()
    }
    
    @objc func startPressed() {
        NotificationCenter.default.post(name: PermissionCell.startButtonPressedNotifiationName, object: nil)
    }
    
    func setupText() {
        let attributedText = NSMutableAttributedString(string: "Skill Summary\n\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22)])
        
        attributedText.append(NSMutableAttributedString(string: "This app is built both programatically and using storyboard. \n\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: "iTunes", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: " :this section is built from scratch without any third-party framework like Alamofire.\nIt includes efficient JSON/RESTful API Clients and customized AVplayer.\n\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: "Yelp", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: ": Yelp section includes Oauth2 and how to handle with token which is saved to keychain. Several frameworks are used like Oauth2, Locksmith, and star-rating.\n\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: "Selfie", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]))
        
        attributedText.append(NSMutableAttributedString(string: ": the core parts of this section are CoreData and CoreImage. After applying a filter to photo taken by you, it's saved to disk. It also has image viewer and zoom features.", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let length = attributedText.string.count
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: length))
        
        summaryLabel.attributedText = attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

