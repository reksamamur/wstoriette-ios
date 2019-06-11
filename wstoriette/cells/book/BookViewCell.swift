//
//  BookViewCell.swift
//  wstoriette
//
//  Created by Reksa on 30/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookViewCell: BaseBookCell {
    
    override var homeBookItem: HomeBookItem! {
        didSet {
            categoryLabel.text = homeBookItem.category
            titleLabel.text = homeBookItem.title
            imageView.image = homeBookItem.image
            descriptionLabel.text = homeBookItem.description
            
            backgroundColor = homeBookItem.backgroundColor
            categoryLabel.textColor = homeBookItem.textColor
            titleLabel.textColor = homeBookItem.textColor
            descriptionLabel.textColor = homeBookItem.textColor
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "allbooks"))
    
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 16
        
        imageView.contentMode = .scaleAspectFill
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
            ], spacing: 8)
        addSubview(stackView)
        
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
