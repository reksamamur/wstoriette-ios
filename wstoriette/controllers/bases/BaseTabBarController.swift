//
//  TabBarController.swift
//  wstoriette
//
//  Created by Reksa on 23/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print(tabBarIndex)
        
        //run login page
        if tabBarIndex == 2 {
            print("ini nomor 2")
            let viewLogin = LoginViewController()
            present(UINavigationController(rootViewController: viewLogin), animated: true)
        }
    }
    
    fileprivate func setupViewController(){
        tabBar.tintColor = .black
        self.tabBarController?.delegate = self
        self.delegate = self
        viewControllers = [
            createController(viewController: BookViewController(), title: "Book", imageName: "book", preferLargeTitles: true),
            createController(viewController: SearchViewController(), title: "Search", imageName: "search", preferLargeTitles: true),
            createController(viewController: WriteViewController(), title: "Write!", imageName: "write", preferLargeTitles: false),
            createController(viewController: AccountViewController(), title: "Account", imageName: "account", preferLargeTitles: true)
        ]
    }
    
    fileprivate func createController(viewController: UIViewController, title: String, imageName: String, preferLargeTitles: Bool) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = preferLargeTitles
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    fileprivate func createControllerWithOutTittle(viewController: UIViewController, title: String, imageName: String, preferLargeTitles: Bool) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = preferLargeTitles
        
        return navController
    }
}
