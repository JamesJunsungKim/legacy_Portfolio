//
//  YelpTransaction.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/6/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

enum YelpTransaction {
    case pickup, delivery, restaurantReservation
}

extension YelpTransaction {
    init?(rawValue: String) {
        switch rawValue {
        case "pickup": self = .pickup
        case "delivery": self = .delivery
        case "restaurant_reservation": self = .restaurantReservation
        default: return nil
        }
    }
}

