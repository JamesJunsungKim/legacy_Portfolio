//
//  YelpBusinessDetailsOperation.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

class YelpBusinessDetailsOperation :Operation {
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
        
        client.updateWithHoursAndPhotos(business) { [unowned self]result in
            switch result {
            case .success(_):
                self.isExecuting = false
                self.isFinished = true
            case .failure(_):
                self.isExecuting = false
                self.isFinished = true
            }
        }
    }
    
    
    
    
    
    
    
}
