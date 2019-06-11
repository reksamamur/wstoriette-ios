//
//  ReadStory.swift
//  wstoriette
//
//  Created by Reksa on 11/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
struct ReadStory: Codable {
    let content: String
    let audio: String
    let data: [data]
}

struct data: Codable {
    let id: Int
    let time: Float
}
