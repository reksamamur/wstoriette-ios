//
//  CommentViewCell.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class CommentRowViewCell: UICollectionViewCell {
    
    let commentHeadLabel = UILabel(text: "Comment", font: .boldSystemFont(ofSize: 25), numberOfLines: 5)
    
    let commentViewController = CommentViewController()
    
    let addcommentButton = UIButton(type: .system)
    /*let usernameLabel = UILabel(text: "Harrry", font: .boldSystemFont(ofSize: 15), numberOfLines: 5)
    
    let commentLabel = UILabel(text: "Harry", font: .systemFont(ofSize: 15))*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addcommentButton.setTitle("Add comment", for: .normal)
        addcommentButton.constrainHeight(constant: 35)
        let stackView = VerticalStackView(arrangedSubviews: [
            
            UIStackView(arrangedSubviews: [
                commentHeadLabel, UIView(), addcommentButton
                ], customSpacing: 15
            ),
            
            commentViewController.view
            
            ], spacing: 15
        )
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
