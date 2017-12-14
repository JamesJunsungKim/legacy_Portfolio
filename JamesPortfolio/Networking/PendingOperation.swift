//
//  PendingOperation.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/3/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

class PendingOperation {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}
