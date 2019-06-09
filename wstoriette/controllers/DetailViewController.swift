//
//  DetailViewController.swift
//  wstoriette
//
//  Created by Reksa on 27/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class DetailViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let detailCellId = "detailCellId"
    var book: ResultJSON!
    
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
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
    }
    
    var detailId: String! {
        didSet {
            //print(detailId)
            let url = "https://itunes.apple.com/lookup?id=\(detailId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: url) { (results: SearchResultJSON?, err) in
                //print(results?.results.first?.trackName ?? "")
                //print(results?.results.first?.description ?? "")
                let book = results?.results.first
                self.book = book
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        setupView()
        setupActivityIndicator()
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
        cell.titleLabel.text = book?.trackName
        cell.bookImageView.sd_setImage(with: URL(string: book?.artworkUrl100 ?? ""))
        cell.descriptionContentLabel.text = book?.description.withoutHtml
        cell.authorLabel.text = book?.artistName
        cell.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        //cell.readsContentLabel.text = "\(book.userRatingCount ?? 0)"
        //cell.appResult = book
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyC = DetailViewCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        dummyC.titleLabel.text = book?.trackName
        dummyC.bookImageView.sd_setImage(with: URL(string: book?.artworkUrl100 ?? ""))
        dummyC.descriptionContentLabel.text = book?.description.withoutHtml
        dummyC.authorLabel.text = book?.artistName
        dummyC.descriptionContentLabel.text = book?.description.withoutHtml
        dummyC.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        //dummyC.readsContentLabel.text = "\(book.userRatingCount ?? 0)"
        //dummyC.appResult = book
        dummyC.layoutIfNeeded()
        
        let estimateSize = dummyC.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
    
    @objc func readStory() {
        let readView = ReadViewController()
        navigationController?.pushViewController(readView, animated: true)
    }
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
