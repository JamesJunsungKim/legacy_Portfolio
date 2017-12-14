//
//  YelpEndpoint.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

enum Yelp {
    enum YelpSortType: CustomStringConvertible {
        case bestMatch, rating, reviewCount, distance
        
        var description: String {
            switch self {
            case .bestMatch: return "best_match"
            case .rating: return "rating"
            case .reviewCount: return "review_count"
            case .distance: return "distance"
            }
        }
    }
    
    case search(term: String, coordinate: Coordinate, radius: Int?, categories: [YelpCategory], limit: Int?, sortBy: YelpSortType?)
    case business(id: String)
    case reviews(businessId: String)
}

extension Yelp: Endpoint {
    var base: String {
        return "https://api.yelp.com"
    }
    var path: String {
        switch self {
        case .search: return "/v3/businesses/search"
        case .business(let id): return "/v3/businesses/\(id)"
        case .reviews(let id): return "/v3/businesses/\(id)/reviews"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let coordinate, let radius, let categories, let limit, let sortBy):
            return [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "latitude", value: coordinate.latitude.description),
                URLQueryItem(name: "longitude", value: coordinate.longitude.description),
                URLQueryItem(name: "radius", value: radius?.description),
                URLQueryItem(name: "categories", value: categories.map({$0.alias}).joined(separator: ",")),
                URLQueryItem(name: "limit", value: limit?.description),
                URLQueryItem(name: "sort_by", value: sortBy?.description)
            ]
        case .business: return []
        case .reviews: return []
        }
    }
}









