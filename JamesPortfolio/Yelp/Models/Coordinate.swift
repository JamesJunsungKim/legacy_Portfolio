//
//  Coordinate.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/6/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: JSONDecodable {
    init?(json: [String : Any]) {
        guard let latitudeValue = json["latitude"] as? Double, let longitudeValue = json["longitude"] as? Double else { return nil }
        self.latitude = latitudeValue
        self.longitude = longitudeValue
    }
}
