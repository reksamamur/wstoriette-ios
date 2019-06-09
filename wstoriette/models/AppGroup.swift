//
//  AppGroup.swift
//  wstoriette
//
//  Created by Reksa on 02/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let id, name, artistName, artworkUrl100: String, userRatingCount: Int?
}
