//
//  CommentViewController.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class CommentViewController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    let commentViewId = "commentViewId"
    fileprivate var appResult = [CommentStory]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(CommentViewCell.self, forCellWithReuseIdentifier: commentViewId)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        let stid = Int(BookMultiViewController.clidid)
        fetchUser(storyId: stid ?? 0)
        setupActivityIndicator()
        
        print("comment get id from multi \(stid)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResult.count
    }
    
    func fetchUser(storyId: Int) {
        let post_url_string = "https://storiette-api.azurewebsites.net/getStoryComment"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("storyId=\(storyId)").data(using: .utf8)
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, err) in
            DispatchQueue.main.async {
                print("finish fetching 2")
                self.activityIndicatorView.stopAnimating()
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    self.appResult = try jDecoder.decode([CommentStory].self, from: data)
                    print(self.appResult)
                    
                    //self.dismiss(animated: true)
                    
                }catch let jsonErr{
                    print(jsonErr)
                    /*let alert = CAlert()
                    alert.initalertDismissNav(on: self, with: "Wrong password or username", message: "Look's like you input wrong username or password")
                    self.usernameField.text = ""
                    self.passwordField.text = ""*/
                }
                self.collectionView.reloadData()
            }
            }.resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentViewId, for: indexPath) as! CommentViewCell
        let cellcom = appResult[indexPath.item]
        cell.userLabel.text = cellcom.username
        cell.commentLabel.text = cellcom.commentText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height)
    }
}
