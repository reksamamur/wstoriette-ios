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
    let username = UserDefaults.standard.string(forKey: "username")
    let statuss = UserDefaults.standard.bool(forKey: "status")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLogout()
    }
    
    func setupLogout() {
        
        if statuss == false {
            tableView.isHidden = true
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(handleSignout))
            tableView.isHidden = false
        }
        
    }
    
    @objc func handleSignout(){
        UserDefaults.standard.set(false, forKey: "status")
        UserDefaults.standard.set("", forKey: "musername")
        UserDefaults.standard.set("", forKey: "username")
        
        let alert = CAlert()
        alert.initalertExit(on: self, with: "You're already sign out now", message: "We'll miss you")
        
        UserDefaults.standard.synchronize()
    }
    
    func setupView() {
        view.clipsToBounds = true
        view.addSubview(tableView)
        
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        tableView.register(AccountViewCell.self, forCellReuseIdentifier: accountCellId)
        setupListAccount()
        
        print("StatusLogin \(statuss)")
        print("Nama AKun \(username ?? "")")
    }
    
    func setupListAccount() {
        listSetting.append(AccountSetting(title: "Profile"))
        listSetting.append(AccountSetting(title: "History"))
        listSetting.append(AccountSetting(title: "Favorite"))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cliked = listSetting[indexPath.item]
        if cliked.title == "History" {
            print("keliked history")
            let historyView = HistoryViewController()
            navigationController?.pushViewController(historyView, animated: true)
        }
        if cliked.title == "Favorite" {
            print("klik favorite")
            let favoriteView = FavaoriteViewController()
            navigationController?.pushViewController(favoriteView, animated: true)
        }
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
