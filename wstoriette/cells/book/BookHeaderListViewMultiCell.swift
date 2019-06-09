//
//  BookHeaderListViewMultiCell.swift
//  wstoriette
//
//  Created by Reksa on 04/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookHeaderListViewMultiCell: UICollectionViewCell {
    
    let categoryLabel = UILabel(text: "Drama", font: .systemFont(ofSize: 25))
    let titleLabel = UILabel(text: "Doing stuff", font: .boldSystemFont(ofSize: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel], spacing: 25)
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
