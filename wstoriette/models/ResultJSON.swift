//
//  ResultJSON.swift
//  wstoriette
//
//  Created by Reksa on 26/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation

class ResultJSON: Decodable {
    let trackName: String
    let artistName: String
    let userRatingCount: Int?
    let artworkUrl100: String
    let trackId: Int
    let description: String
}
