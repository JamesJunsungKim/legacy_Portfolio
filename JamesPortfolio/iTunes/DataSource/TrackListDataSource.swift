//
//  TrackListDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/11/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class TrackListDataSource: NSObject, UITableViewDataSource {


    var albumTrackCollection = [[Track]]()
    var currentTrack : Track?
    var currentIndexPath: Int?
    var sections = [String]()
    

    init(with tracks: [[Track]]) {
        self.albumTrackCollection = tracks
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumTrackCollection[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackListCell", for: indexPath) as! TrackListCell
        let track = albumTrackCollection[indexPath.section][indexPath.row]
        cell.configure(with: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    



    // MARK: - Helper

    func update(with tracks: [Track], at currentIndexPath: Int) {
        
        var tempTracks = tracks
        tempTracks.remove(at: currentIndexPath)
        self.currentIndexPath = currentIndexPath
        self.currentTrack = tracks[currentIndexPath]
        albumTrackCollection.removeAll()
        albumTrackCollection.append([currentTrack!])
        albumTrackCollection.append(tempTracks)
        sections = ["Now Playing", "Next From: \(currentTrack!.albumName)"]
        }
    
    func retrieveTrackQueue() -> [Track] {
        return albumTrackCollection[1]
    }
    
    func track(at indexPath: IndexPath) -> Track {
        return albumTrackCollection[1][indexPath.row]
    }
}

