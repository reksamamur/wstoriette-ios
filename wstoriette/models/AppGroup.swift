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

struct GetStories: Decodable {
    let id: String
    let author: String
    let img: String
    let title: String
    let synopsis: String
    let reads: Int
    let date: String
    let rating: Int
}
