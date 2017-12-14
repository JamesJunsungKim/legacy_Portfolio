//
//  YelpClient.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

class YelpClient: APIClient {
    let session: URLSession
    private let token: String
    
    init(configuration: URLSessionConfiguration, oauthToken: String) {
        self.session = URLSession(configuration: configuration)
        self.token = oauthToken
    }
    
    convenience init(oauthToken: String) {
        self.init(configuration: .default, oauthToken: oauthToken)
    }
    
    func search(withTerm term: String, at coordinate: Coordinate, categories:[YelpCategory] = [], radius : Int? = nil, limit: Int = 50, sortBy sortType: Yelp.YelpSortType = .rating, completion: @escaping (Result<[YelpBusiness], APIError>)->Void) {
        let endpoint = Yelp.search(term: term, coordinate: coordinate, radius: radius, categories: categories, limit: limit, sortBy: sortType)
        
        let request = endpoint.requestWithAuthorizationheader(oauthToken: token)
        
        fetch(with: request, parse: { json -> [YelpBusiness] in
            guard let businesses = json["businesses"] as? [[String:Any]] else {return []}
            return businesses.flatMap{YelpBusiness(json:$0)}
        }, completion: completion)
    }
    
    
    func businessWithId(_ id: String, completion: @escaping (Result<YelpBusiness,APIError>)->Void) {
        let endpoint = Yelp.business(id: id)
        let request = endpoint.requestWithAuthorizationheader(oauthToken: token)
        
        fetch(with: request, parse: { json -> YelpBusiness? in
            guard let json = json else {return nil}
            return YelpBusiness(json: json)
        }, completion: completion)
    }
    
    func updateWithHoursAndPhotos(_ business: YelpBusiness, completion: @escaping (Result<YelpBusiness,APIError>)->Void){
        let endpoint = Yelp.business(id: business.id)
        let request = endpoint.requestWithAuthorizationheader(oauthToken: token)
        
        fetch(with: request, parse: { json -> YelpBusiness? in
            guard let json = json else {return nil}
            business.updateWithHoursAndPhotos(json: json)
            return business
        }, completion: completion)
    }
    
    func reviews(for business: YelpBusiness, completion: @escaping (Result<[YelpReview],APIError>)->Void) {
        let endpoint = Yelp.reviews(businessId: business.id)
        let request = endpoint.requestWithAuthorizationheader(oauthToken: token)
        
        fetch(with: request, parse: { json -> [YelpReview] in
            guard let reviews = json["reviews"] as? [[String:Any]] else {return []}
            return reviews.flatMap{YelpReview(json:$0)}
        }, completion: completion)
    }

}

















