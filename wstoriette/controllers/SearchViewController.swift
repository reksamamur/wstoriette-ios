//
//  SearchViewController.swift
//  wstoriette
//
//  Created by Reksa on 24/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let cellID = "cellid"
    fileprivate var appResult = [ResultJSON]()
    fileprivate var categoryArr = [Category]()
    
    let titleCat: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        return label
    }()
    
    fileprivate let category: UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = .white
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategory()
        setupSearchBar()
    }
    
    func setupCategory() {
        category.frame = CGRect.init(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        collectionView.addSubview(category)
        category.delegate = self
        category.dataSource = self
        category.register(CategoryCell.self, forCellReuseIdentifier: "catcell")
        
        categoryArr.append(Category(categoryName: "Comedy", categoryIcon: "comedy"))
        categoryArr.append(Category(categoryName: "Drama", categoryIcon: "drama"))
        categoryArr.append(Category(categoryName: "Action", categoryIcon: "action"))
        categoryArr.append(Category(categoryName: "Adventure", categoryIcon: "compas"))
        categoryArr.append(Category(categoryName: "Fantasy", categoryIcon: "fantasy"))
        categoryArr.append(Category(categoryName: "Fiction", categoryIcon: "sci-fi"))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let convert = titleCat.text
        return convert
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = category.dequeueReusableCell(withIdentifier: "catcell", for: indexPath) as! CategoryCell
        cell.textLabel?.text = categoryArr[indexPath.item].categoryName
        cell.imageView?.image = UIImage(named: categoryArr[indexPath.item].categoryIcon)
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cliked = categoryArr[indexPath.item]
        let categoryView = CategoryViewController()
        categoryView.categoryName = cliked.categoryName
        categoryView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(categoryView, animated: true)
    }
    
    fileprivate func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    fileprivate func setupSearchBar(){
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Service.shared.fetch(searchTerm: searchText) { (res, err) in
            self.appResult = res
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        category.isHidden = appResult.count != 0
        return appResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchViewCell
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
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented)")
    }
}
