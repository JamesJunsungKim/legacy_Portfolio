//
//  APIClient.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/8/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

protocol APIClient {
    var session: URLSession {get}
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON?)-> T?, completion: @escaping (Result<T,APIError>)-> Void)
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> [T], completion: @escaping (Result<[T],APIError>)-> Void)
}

extension APIClient {
    typealias JSON = [String:AnyObject]
    typealias JSONCompletionHandler = (JSON?, APIError?)-> Void
    
    func jsonTask(with request: URLRequest,completionHandler completion: @escaping JSONCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(nil, .requestFailed)
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON?)-> T?, completion: @escaping (Result<T,APIError>)-> Void) {
        
        let task = jsonTask(with: request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(.failure(.invalidData))
                    }
                    return
                }
                if let value = parse(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    func fetch<T:JSONDecodable>(with request: URLRequest, parse: @escaping (JSON)-> [T], completion: @escaping (Result<[T], APIError>)-> Void) {
        let task = jsonTask(with: request) { (json, error) in
            DispatchQueue.main.async {
                
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.invalidData))
                    }
                    return
                }
                
                let value = parse(json)
                
                if !value.isEmpty {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }

}
