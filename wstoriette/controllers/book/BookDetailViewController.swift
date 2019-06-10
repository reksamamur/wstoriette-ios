//
//  BookDetailViewController.swift
//  wstoriette
//
//  Created by Reksa on 04/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookDetailViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let detailCellId = "detailCellId"
    var book: GetStories!
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        aiv.backgroundColor = .white
        return aiv
    }()
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    var ftitle: String?
    var fimg: String?
    var fsynopsis: String?
    var fauthor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupClosebtn()
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
    }
    
    func setupView() {
        collectionView.backgroundColor = .white
        collectionView.register(DetailViewCell.self, forCellWithReuseIdentifier: detailCellId)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! DetailViewCell
        cell.titleLabel.text = ftitle
        cell.bookImageView.sd_setImage(with: URL(string: fimg ?? ""))
        cell.descriptionContentLabel.text = fsynopsis?.withoutHtml
        cell.authorLabel.text = fauthor
        cell.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        //cell.readsContentLabel.text = "\(book.userRatingCount ?? 0)"
        //cell.appResult = book
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyC = DetailViewCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        dummyC.titleLabel.text = ftitle
        dummyC.bookImageView.sd_setImage(with: URL(string: fimg ?? ""))
        dummyC.descriptionContentLabel.text = fsynopsis?.withoutHtml
        dummyC.authorLabel.text = fauthor
        dummyC.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        //dummyC.readsContentLabel.text = "\(book.userRatingCount ?? 0)"
        
        //dummyC.appResult = book
        dummyC.layoutIfNeeded()
        
        let estimateSize = dummyC.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 50, left: 20, bottom: 20, right: 20)
    }
    
    @objc func readStory() {
        let readView = ReadViewController()
        navigationController?.pushViewController(readView, animated: true)
    }
}
