//
//  AccountViewController.swift
//  wstoriette
//
//  Created by Reksa on 09/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listSetting = [AccountSetting]()
    let tableView = UITableView(frame: .zero, style: .plain)
    let accountCellId = "accountCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.clipsToBounds = true
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        tableView.register(AccountViewCell.self, forCellReuseIdentifier: accountCellId)
        setupListAccount()
    }
    
    func setupListAccount() {
        listSetting.append(AccountSetting(title: "Profile"))
        listSetting.append(AccountSetting(title: "Draft"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: accountCellId, for: indexPath) as! AccountViewCell
        cell.titleLabel.text = listSetting[indexPath.item].title
        return cell
    }
}
