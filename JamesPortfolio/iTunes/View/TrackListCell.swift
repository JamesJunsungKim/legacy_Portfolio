//
//  TrackListCell.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/11/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class TrackListCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    func configure(with track: Track) {
        self.trackNameLabel.text = track.name
        self.artistNameLabel.text = track.artistName
        
    }
}
