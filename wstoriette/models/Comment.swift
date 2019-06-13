//
//  Comment.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation

struct CommentStory: Codable {
    let commentID: Int
    let StoryHeaderID: String
    let username: String
    let commentText: String
}
