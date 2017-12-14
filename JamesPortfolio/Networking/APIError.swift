//
//  ItunesError.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

enum APIError: Error{
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self{
        case .requestFailed: return "Request Failed"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .invalidData: return "Invalid data"
        case .jsonConversionFailure: return "conversionFailure"
        case .jsonParsingFailure: return "json parsing failure"
        }
    }
}
