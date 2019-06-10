//
//  LoginViewController.swift
//  wstoriette
//
//  Created by Reksa on 10/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let loginView = UIView()
    
    func setupView() {
        loginView.clipsToBounds = true
        loginView.backgroundColor = .blue
        view.addSubview(loginView)
        
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        let topPadding = UIApplication.shared.statusBarFrame.height
        loginView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: topPadding+55, left: 25, bottom: bottomPadding, right: 25), size: .init(width: 0, height: view.frame.height))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        loginView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
    }
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.tintColor = .darkGray
        return btn
    }()
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        setupClosebtn()
        setupView()
    }
}
