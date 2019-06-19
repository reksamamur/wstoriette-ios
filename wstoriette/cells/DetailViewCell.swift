//
//  DetailViewCell.swift
//  wstoriette
//
//  Created by Reksa on 27/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    
    let bookImageView = UIImageView(cornerRadius: 10)
    
    let titleLabel = UILabel(text: "Harrry", font: .boldSystemFont(ofSize: 25), numberOfLines: 5)
    
    let authorLabel = UILabel(text: "Harry", font: .systemFont(ofSize: 15))
    
    let readButton = UIButton(title: "Read")
    
    let authorPlcLabel = UILabel(text: "Author", font: .boldSystemFont(ofSize: 20))
    
    let descriptionLabel = UILabel(text: "Description", font: .boldSystemFont(ofSize: 20))
    
    let descriptionContentLabel = UILabel(text: "Content", font: .systemFont(ofSize: 15), numberOfLines: 0)
    
    let readsLabel = UILabel(text: "Reads", font: .boldSystemFont(ofSize: 20))
    
    let readsContentLabel = UILabel(text: "Content", font: .systemFont(ofSize: 15), numberOfLines: 0)
    
    let favLabel = UILabel(text: "Favorite", font: .boldSystemFont(ofSize: 20))
    
    let favContentLabel = UILabel(text: "Content", font: .systemFont(ofSize: 15), numberOfLines: 0)
    
    let categoryLabel = UILabel(text: "Fiction", font: .systemFont(ofSize: 15))
    
    let favoriteButton = UIButton(title: "Favorite")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bookImageView.backgroundColor = .white
        bookImageView.constrainWidth(constant: 150)
        bookImageView.constrainHeight(constant: 220)
        readButton.backgroundColor = .clear
        readButton.layer.borderWidth = 2
        readButton.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        readButton.constrainHeight(constant: 35)
        readButton.layer.cornerRadius = 8
        readButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        readButton.setTitleColor(.black, for: .normal)
        favoriteButton.setTitleColor(.black, for: .normal)
        favoriteButton.backgroundColor = .clear
        favoriteButton.layer.borderWidth = 2
        favoriteButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        favoriteButton.constrainHeight(constant: 35)
        favoriteButton.layer.cornerRadius = 8
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        favoriteButton.setTitleColor(.black, for: .normal)
        descriptionContentLabel.textAlignment = .justified
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                bookImageView,
                VerticalStackView(arrangedSubviews: [
                    titleLabel,
                    readButton,
                    favoriteButton,
                    UIView()
                    ], spacing: 12)
                ], customSpacing: 20),
            authorPlcLabel,
            authorLabel,
            descriptionLabel,
            descriptionContentLabel,
            UIStackView(arrangedSubviews: [
                readsLabel,
                UIView(),
                UIView(),
                readsContentLabel
                ], customSpacing: 0),
            UIStackView(arrangedSubviews: [
                favLabel,
                UIView(),
                UIView(),
                favContentLabel
                ], customSpacing: 0),
            ], spacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var appResult: ResultJSON! {
        didSet {
            titleLabel.text = appResult.trackName
            bookImageView.sd_setImage(with: URL(string: appResult.artworkUrl100 ))
            descriptionContentLabel.text = appResult.description.withoutHtml
            authorLabel.text = appResult.artistName
            readsContentLabel.text = "\(appResult.userRatingCount ?? 0)"
        }
    }
}
