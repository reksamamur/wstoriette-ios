//
//  BookFullScreenViewController.swift
//  wstoriette
//
//  Created by Reksa on 02/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BookFullScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dismissHandler: (() ->())?
    var homeBookItem: HomeBookItem?
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        
        setupCloseButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = BookFullscreenHeaderCell()
            headerCell.bookViewCell.homeBookItem = homeBookItem
            headerCell.bookViewCell.layer.cornerRadius = 16
            return headerCell
        }
        
        let cell = BookFullScreenDescriptionViewCell()
        return cell
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        return button
    }()
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return BookViewController.cellSize
        }
        return UITableView.automaticDimension
    }
}
