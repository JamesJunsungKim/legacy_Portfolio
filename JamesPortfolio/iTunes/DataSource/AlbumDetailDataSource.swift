//
//  AlbumDetailDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class AlbumDetailDataSource: NSObject, UITableViewDataSource {
    
    private var tracks: [Track]
    
    init(tracks: [Track]) {
        self.tracks = tracks
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.indexPath = indexPath
        cell.senderButton.tag = indexPath.row
        cell.track = tracks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Track"
        default: return nil
        }
    }
    
    // MARK: - Helper
    
    func update(with album: Album) {
        self.tracks = album.tracks
    }
    
    func track(at indexPath: IndexPath) -> Track {
        return tracks[indexPath.row]
    }
    
    func track(at int: Int) -> Track {
        return tracks[int]
    }
    
    func albumTrack()-> [Track] {
        return self.tracks
    }
    
}
