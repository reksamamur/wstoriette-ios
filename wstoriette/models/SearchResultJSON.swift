//
//  SearchResultJSON.swift
//  wstoriette
//
//  Created by Reksa on 26/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation

/*struct SearchResultJSON: Decodable {
    let resultCount: Int
    let results: [ResultJSON]
    
}*/

class SearchResultJSON: Decodable {
    let resultCount: Int
    let results: [ResultJSON]
}
