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
    let commentCellId = "commentCellId"
    var book: GetStories!
    let username = UserDefaults.standard.string(forKey: "username")
    
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
    var fid: String?
    var storyID = Int(BookMultiViewController.clidid) ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupClosebtn()
        print("fid parent \(BookMultiViewController.clidid)")
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
    }
    
    func setupView() {
        collectionView.backgroundColor = .white
        collectionView.register(DetailViewCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(CommentRowViewCell.self, forCellWithReuseIdentifier: commentCellId)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! DetailViewCell
            cell.titleLabel.text = ftitle
            cell.bookImageView.sd_setImage(with: URL(string: fimg ?? ""))
            cell.descriptionContentLabel.text = fsynopsis?.withoutHtml
            cell.authorLabel.text = fauthor
            cell.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
            cell.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
            //cell.appResult = book
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentRowViewCell
            cell.addcommentButton.addTarget(self, action: #selector(popUpComment), for: .touchUpInside)
            return cell
        }
    }
    
    var commentText: String?
    
    @objc func popUpComment(){
        
        let alertController = UIAlertController(title: "Post comment", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Post", style: .default) { [unowned self](action) in
            guard let textField = alertController.textFields?.first, let itemToAdd = textField.text else {return}
            self.commentText = itemToAdd
            self.fetchPostComment(storyID: self.storyID, username: self.username ?? "", commentText: self.commentText ?? "")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchPostComment(storyID: Int, username: String, commentText: String) {
        let post_url_string = "https://storiette-api.azurewebsites.net/postStoryComment"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("username=\(username)&storyId=\(storyID)&commentText=\(commentText)").data(using: .utf8)
        
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
                    let result = try jDecoder.decode(CommentPostStory.self, from: data)
                    print("status add post comment \(result)")
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalert(on: self, with: "Woopss something wrong", message: "we don't know yet")
                }
            }
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            let dummyC = DetailViewCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            
            dummyC.titleLabel.text = ftitle
            dummyC.bookImageView.sd_setImage(with: URL(string: fimg ?? ""))
            dummyC.descriptionContentLabel.text = fsynopsis?.withoutHtml
            dummyC.authorLabel.text = fauthor
            dummyC.readButton.addTarget(self, action: #selector(readStory), for: .touchUpInside)
            dummyC.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
            
            //dummyC.appResult = book
            dummyC.layoutIfNeeded()
            
            let estimateSize = dummyC.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            return .init(width: view.frame.width, height: estimateSize.height)
        }else{
            return .init(width: view.frame.width, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 55, left: 0, bottom: 20, right: 0)
    }
    
    @objc func readStory() {
        let readView = ReadViewController()
        readView.fid = fid
        readView.ftitle = self.ftitle
        readView.imgURLTumb = self.fimg
        navigationController?.pushViewController(readView, animated: true)
    }
    
    @objc func addToFavorite(){
        print("kepencet")
        fetchFavorite(storyID: Int(fid!) ?? 0, username: self.username ?? "")
        let alert = CAlert()
        alert.initalert(on: self, with: "Added to favorite", message: "we add this story to favorite")
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
                    print("status add to favorite \(result)")
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalert(on: self, with: "Woopss something wrong", message: "we don't know yet")
                }
            }
        }.resume()
    }
}
