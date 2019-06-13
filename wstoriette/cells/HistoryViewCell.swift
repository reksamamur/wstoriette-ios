//
//  HistoryViewCell.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class HistoryViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgv.heightAnchor.constraint(equalToConstant: 145).isActive = true
        imgv.layer.cornerRadius = 8
        imgv.clipsToBounds = true
        return imgv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let readsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    fileprivate func setupCell(){
        let labelStackview = UIStackView(arrangedSubviews: [
            nameLabel
            ])
        labelStackview.axis = .vertical
        labelStackview.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, labelStackview
            ])
        stackView.spacing = 12
        stackView.alignment = .top
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
