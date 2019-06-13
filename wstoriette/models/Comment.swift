//
//  Comment.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation

struct CommentStory: Codable {
    let CommentID: Int
    let StoryHeaderID: Int
    let usernam: String
    let commentText: String
}
