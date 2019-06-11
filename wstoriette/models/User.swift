//
//  User.swift
//  wstoriette
//
//  Created by Reksa on 10/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
struct User: Codable {
    let username: String
    let password: String
}

struct UserResult: Codable {
    let status: String
    let username: String
}
