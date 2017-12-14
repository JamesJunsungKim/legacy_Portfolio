//
//  Result.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

enum Result<T,U>where U: Error {
    case success(T)
    case failure(U)
}
