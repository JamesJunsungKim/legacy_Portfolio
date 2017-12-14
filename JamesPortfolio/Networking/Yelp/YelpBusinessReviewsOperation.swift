//
//  YelpBusinessDetailsOperation.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class YelpBusinessReviewsOperation :Operation {
    let business: YelpBusiness
    let client: YelpClient
    
    init(business: YelpBusiness, client: YelpClient) {
        self.business = business
        self.client = client
        super.init()
    }
    
    override var isAsynchronous: Bool{
        return true
    }
    
    private var _finished = false
    private var _excecuting = false
    
    override var isFinished: Bool {
        get {
            return _finished
        }
        
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isExecuting: Bool {
        get {
            return _excecuting
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _excecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override func main() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        client.reviews(for: business) { [unowned self]result in
            switch result{
            case .success(let reviews):
                for review in reviews {
                    guard let url = URL(string: review.user.imageUrl) else {return}
                    let imageData = try! Data(contentsOf: url)
                    
                    if imageData.count > 0 {
                        review.user.image = UIImage(data: imageData)
                        review.user.imageState = .downloaded
                    } else {
                        review.user.imageState = .failed
                    }
                }
                self.business.reviews = reviews
                self.isExecuting = false
                self.isFinished = true
            case .failure(let error):
                print(error)
                self.isExecuting = false
                self.isFinished = true
            }
        }
    }
    
    
    
    
    
    
    
}

