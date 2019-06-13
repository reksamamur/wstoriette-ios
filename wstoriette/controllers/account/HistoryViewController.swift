//
//  HistoryViewController.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
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
    
    let historyCellId = "historyCellId"
    
    fileprivate var appResult = [HistoryUser]()
    
    struct HistoryUser: Codable {
        let StoryId: String
        let Title: String
        let thumbnail: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HistoryViewCell.self, forCellWithReuseIdentifier: historyCellId)
        setupActivityIndicator()
        fetchData(username: username ?? "")
        navigationItem.title = "History"
    }
    
    func fetchData(username: String) {
        let post_url_string = "https://storiette-api.azurewebsites.net/getUserHistory"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("username=\(username)").data(using: .utf8)
        
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
                    /*let result = try jDecoder.decode([HistoryUser].self, from: data)
                    self.appResult = result*/
                    
                    self.appResult = try jDecoder.decode([HistoryUser].self, from: data)
                    
                    print(self.appResult)
                    
                    /*self.collectionView.reloadData()*/
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalertDismissNav(on: self, with: "Something Wrong", message: "we don't know yet")
                }
                self.collectionView.reloadData()
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(appResult.count)
        return appResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCellId, for: indexPath) as! HistoryViewCell
        let cresult = appResult[indexPath.item]
        cell.nameLabel.text = cresult.Title
        cell.imageView.sd_setImage(with: URL(string: cresult.thumbnail))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Kliked")
    }
}
