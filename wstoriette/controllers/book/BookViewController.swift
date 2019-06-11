//
//  BookViewController.swift
//  wstoriette
//
//  Created by Reksa on 02/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var bookFullScreenViewController: BookFullScreenViewController!
    
    var startingFrame: CGRect?
    
    static let cellSize: CGFloat = 500
    
    var items = [HomeBookItem]()
    var getstories = [GetStories]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.superview?.setNeedsLayout() 
        setupView()
        /*fetchData()*/
        setupActivityIndicator()
        fetchStories()
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    func setupView() {
        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: HomeBookItem.CellType.single.rawValue)
        collectionView.register(BookViewMultiCell.self, forCellWithReuseIdentifier: HomeBookItem.CellType.multi.rawValue)
    }
    
    func fetchStories() {
        let realURl = "https://storiette-api.azurewebsites.net/getStories"
        guard let urlMain = URL(string: realURl) else {return}
        URLSession.shared.dataTask(with: urlMain) { (data, _, err) in
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
                    self.getstories = try jDecoder.decode([GetStories].self, from: data)
                    
                    self.items = [
                        HomeBookItem.init(category: "Latest Story", title: "You'll never miss this one, Okay?", image: #imageLiteral(resourceName: "book1"), description: "", backgroundColor: #colorLiteral(red: 0.8823529412, green: 0.8901960784, blue: 0.8980392157, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cellType: .single, bookResults: self.getstories)
                    ]
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
                self.collectionView.reloadData()
            }
        }.resume()
    }
    
    /*func fetchData() {
        var fBook: AppGroup?
        var fTopGrossing: AppGroup?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchBook { (appGroup, err) in
            fBook = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            fTopGrossing = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("finish fetching")
            self.activityIndicatorView.stopAnimating()
            /*self.items = [
                HomeBookItem.init(category: "Latest Story", title: "You'll never miss this one, Okay?", image: #imageLiteral(resourceName: "book1"), description: "", backgroundColor: #colorLiteral(red: 0.8823529412, green: 0.8901960784, blue: 0.8980392157, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cellType: .single, bookResults: fBook?.feed.results ?? []),
                HomeBookItem.init(category: "Romance", title: "Find out how beautiful you are", image: #imageLiteral(resourceName: "book2"), description: "", backgroundColor: .black, textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .single, bookResults: fTopGrossing?.feed.results ?? []),
                HomeBookItem.init(category: "Comedy", title: "Sometimes you just have to enjoy yourself", image: #imageLiteral(resourceName: "marcela-rogante-432403-unsplash"), description: "", backgroundColor: #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9529411765, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cellType: .single, bookResults: fBook?.feed.results ?? []),
                HomeBookItem.init(category: "Horror", title: "Knock! Knock! whos there?", image: #imageLiteral(resourceName: "christian-holzinger-502231-unsplash"), description: "", backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellType: .single, bookResults: fBook?.feed.results ?? []),
            ]*/
            self.collectionView.reloadData()
        }
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .single {
            let listFullScreenController = BookMultiViewController(mode: .fullscreen)
            listFullScreenController.results = self.items[indexPath.item].bookResults
            present(UINavigationController(rootViewController: listFullScreenController), animated: true)
            return
        }
        
        /*let bookFullScreenViewController = BookFullScreenViewController()
        bookFullScreenViewController.homeBookItem = items[indexPath.item]
        bookFullScreenViewController.dismissHandler = {
            self.handleRemoveView()
        }
        
        let fullScreenView = bookFullScreenViewController.view!
        view.addSubview(fullScreenView)
        
        addChild(bookFullScreenViewController)
        
        self.bookFullScreenViewController = bookFullScreenViewController
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {
            return
        }
        
        self.startingFrame = startingFrame
        
        fullScreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()
        
        fullScreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.navigationController?.navigationBar.isHidden = true
            
            guard let cell = self.bookFullScreenViewController.tableView.cellForRow(at: [0, 0]) as? BookFullscreenHeaderCell else { return }
            
            cell.bookViewCell.topConstraint.constant = 55
            cell.layoutIfNeeded()
            
        }, completion: nil)*/
    }
    
    @objc func handleRemoveView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.bookFullScreenViewController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.bookFullScreenViewController.tableView.cellForRow(at: [0, 0]) as? BookFullscreenHeaderCell else { return }
            
            cell.bookViewCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.bookFullScreenViewController.view.removeFromSuperview()
            self.bookFullScreenViewController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isHidden = false
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseBookCell
        cell.homeBookItem = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: BookViewController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
