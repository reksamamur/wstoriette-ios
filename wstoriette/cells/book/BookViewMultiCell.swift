//
//  BookListViewCell.swift
//  wstoriette
//
//  Created by Reksa on 01/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookViewMultiCell: BaseBookCell {
    
    override var homeBookItem: HomeBookItem! {
        didSet {
            categoryLabel.text = homeBookItem.category
            titleLabel.text = homeBookItem.title
            multipleAppsController.results = homeBookItem.bookResults
            multipleAppsController.collectionView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
    
    let multipleAppsController = BookMultiViewController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        
        multipleAppsController.view.backgroundColor = .red
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            multipleAppsController.view
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
