//
//  CommentViewCell.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class CommentViewCell: UICollectionViewCell {
    
    let userLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    
    let commentLabel = UILabel(text: "Review body\nReview body\nReview body\n", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            userLabel,
            commentLabel
            ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
