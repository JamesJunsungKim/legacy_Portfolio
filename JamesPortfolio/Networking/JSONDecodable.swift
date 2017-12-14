//
//  JSONDecodable.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/6/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

protocol JSONDecodable{
    init?(json:[String:Any])
}
