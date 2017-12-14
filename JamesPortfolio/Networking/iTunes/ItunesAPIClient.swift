//
//  ItunesAPIClient.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import Foundation

class ItunesAPIClient {
    
    let downloader = JSONdownloader()
    
    func searchForArtists(withTerm term: String, completion: @escaping ([Artist], APIError?)-> Void){
        let endpoint = Itunes.search(term: term, media: .music(entity: .musicArtist, attribute: .artistTerm))
        
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion([], error)
                return
            }
            let artists = results.flatMap{Artist(json:$0)}
            completion(artists, nil)
        }
    }
    
    func lookupArtist(with id: Int, completion: @escaping (Artist?, APIError?)-> Void) {
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.album)
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            guard let artistInfo = results.first else {
                completion(nil, .jsonParsingFailure)
                return
            }
            guard let artist = Artist(json: artistInfo) else {
                completion(nil, .jsonParsingFailure)
                return
            }
            let albumResults = results[1..<results.count]
            let albums = albumResults.flatMap{Album(json:$0)}
            
            artist.albums = albums
            completion(artist, nil)
        }
    }
    
    func lookupAlbum(with id: Int, completion: @escaping (Album?, APIError?)-> Void) {
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.song)
        
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            guard let albumInfo = results.first else {
                completion(nil, .jsonParsingFailure)
                return
            }
            guard let album = Album(json: albumInfo) else {
                completion(nil, .jsonParsingFailure)
                return
            }
            let songResults = results[1..<results.count]
            let tracks = songResults.flatMap{Track(json:$0)}
            album.tracks = tracks
            completion(album, nil)
        }
    }
    
    
    // MARK: Helper
    
    typealias Results = [[String:Any]]
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, APIError?) -> Void) {
        let task = downloader.jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                guard let results = json["results"] as? [[String:Any]] else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                completion(results, nil)
            }
        }
        task.resume()
    }
}
