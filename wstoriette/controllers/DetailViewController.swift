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
    let username = UserDefaults.standard.string(forKey: "username")
    
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
            let url = "https://itunes.apple.com/lookup?id=\(detailId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: url) { (results: SearchResultJSON?, err) in
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
    
    var ftitle: String?
    var fimg: String?
    var fsynopsis: String?
    var fauthor: String?
    var fid: String?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! DetailViewCell
        cell.titleLabel.text = book?.trackName
        self.ftitle = book?.trackName
        cell.bookImageView.sd_setImage(with: URL(string: book?.artworkUrl100 ?? ""))
        self.fimg = book?.artworkUrl100
        cell.descriptionContentLabel.text = book?.description.withoutHtml
        self.fsynopsis = book?.description.withoutHtml
        cell.authorLabel.text = book?.artistName
        cell.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        cell.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyC = DetailViewCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        dummyC.titleLabel.text = book?.trackName
        self.ftitle = book?.trackName
        dummyC.bookImageView.sd_setImage(with: URL(string: book?.artworkUrl100 ?? ""))
        self.fimg = book?.artworkUrl100
        dummyC.descriptionContentLabel.text = book?.description.withoutHtml
        self.fsynopsis = book?.description.withoutHtml
        dummyC.authorLabel.text = book?.artistName
        dummyC.descriptionContentLabel.text = book?.description.withoutHtml
        dummyC.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
        dummyC.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        dummyC.layoutIfNeeded()
        
        let estimateSize = dummyC.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
    
    @objc func readStory() {
        let readView = ReadViewController()
        self.fid = "\(0)"
        readView.fid = self.fid
        readView.ftitle = self.ftitle
        readView.imgURLTumb = self.fimg
        navigationController?.pushViewController(readView, animated: true)
    }
    
    @objc func addToFavorite(){
        print("kepencet")
        /*fetchFavorite(storyID: Int(self.fid!) ?? 0, username: self.username ?? "")
        let alert = CAlert()
        alert.initalert(on: self, with: "Added to favorite", message: "we add this story to favorite")*/
    }
    
    func fetchFavorite(storyID: Int, username: String) {
        let post_url_string = "https://storiette-api.azurewebsites.net/postUserFavorite"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("username=\(username)&storyId=\(storyID)").data(using: .utf8)
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, err) in
            DispatchQueue.main.async {
                print("finish fetching 2")
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    let result = try jDecoder.decode(UserFavorite.self, from: data)
                    print("status regis \(result)")
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalert(on: self, with: "Woopss something wrong", message: "we don't know yet")
                }
            }
            }.resume()
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
