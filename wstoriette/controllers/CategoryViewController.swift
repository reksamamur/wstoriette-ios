//
//  CategoryViewController.swift
//  wstoriette
//
//  Created by Reksa on 09/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class CategoryViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var appResult = [ResultJSON]()
    
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
    
    var categoryName: String! {
        didSet {
            navigationItem.title = categoryName
        }
    }
    
    let categoryCellId = "categoryCellId"
    var results = [FeedResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: categoryCellId)
        fetchData()
        setupActivityIndicator()
    }
    
    func fetchData() {
        Service.shared.fetch(searchTerm: self.categoryName) { (res, err) in
            self.appResult = res
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! SearchViewCell
        cell.appResult = appResult[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clicked = appResult[indexPath.item]
        print(clicked.trackName)
        let detailController = DetailViewController()
        let trackStringId = String(clicked.trackId)
        detailController.detailId = trackStringId
        /*let backButton = UIBarButtonItem()
         backButton.title = "Back"
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton*/
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}
