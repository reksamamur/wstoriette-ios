//
//  BookFullscreenVieweHeaderCell.swift
//  wstoriette
//
//  Created by Reksa on 01/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookFullscreenHeaderCell: UITableViewCell {

    let bookViewCell = BookViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bookViewCell)
        bookViewCell.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
