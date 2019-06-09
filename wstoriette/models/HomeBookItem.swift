//
//  HomeBookItem.swift
//  wstoriette
//
//  Created by Reksa on 01/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

struct HomeBookItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    let textColor: UIColor
    
    let cellType: CellType
    
    let bookResults: [FeedResult]
    
    enum CellType: String {
        case single
        case multi
    }
}
