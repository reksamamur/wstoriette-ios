//
//  BookMultiViewController.swift
//  wstoriette
//
//  Created by Reksa on 02/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookMultiViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    static var clidid: String!
    var results = [GetStories]()
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let titleLabel = UILabel(text: "Tittle", font: .boldSystemFont(ofSize: 25))
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullscreen {
            setupClosebtn()
        }else{
            collectionView.isScrollEnabled = false
        }
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.register(BookListViewMultiCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 55, left: 20, bottom: 0, right: 20), size: .init(width: 35, height: 35))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen {
            return results.count
        }
        return min(4, results.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clicked = results[indexPath.item]
        
        BookMultiViewController.clidid = clicked.id
        
        if mode == .fullscreen {
            let mview = BookDetailViewController()
            mview.ftitle = clicked.title
            mview.fimg = clicked.img
            mview.fsynopsis = clicked.synopsis
            mview.fauthor = clicked.author
            mview.fid = BookMultiViewController.clidid
            
            navigationController?.pushViewController(mview, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookListViewMultiCell
        cell.app = self.results[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if mode == .fullscreen {
            let height: CGFloat = 120
            return .init(width: view.frame.width - 50, height: height)
        }
        
        let height: CGFloat = (view.frame.width - 1 * spacing) / 3
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 85, left: 20, bottom: 20, right: 20)
        }
        return .zero
    }
    
    fileprivate let spacing: CGFloat = 20
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}
