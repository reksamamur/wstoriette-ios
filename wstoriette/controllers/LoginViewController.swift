//
//  LoginViewController.swift
//  wstoriette
//
//  Created by Reksa on 10/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let loginView = UIView()
    private var currentTextField: UITextField?
    
    let usernameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.placeholder = "username"
        field.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        field.layer.borderWidth = 1.5
        field.layer.cornerRadius = 5
        field.autocorrectionType = .no
        field.setAnchor(witdh: 0, height: 50)
        field.setLeftPaddingPoint(20)
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.placeholder = "password"
        field.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        field.layer.borderWidth = 1.5
        field.layer.cornerRadius = 5
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.setAnchor(witdh: 0, height: 50)
        field.setLeftPaddingPoint(20)
        return field
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(title: "Sign in")
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.8509803922, blue: 0.2431372549, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setAnchor(witdh: 0, height: 45)
        return btn
    }()
    
    let registerButton: UIButton = {
        let btn = UIButton(title: "Sign up")
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = #colorLiteral(red: 1, green: 0.8509803922, blue: 0.2431372549, alpha: 1)
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        btn.setAnchor(witdh: 0, height: 45)
        return btn
    }()
    
    func setupView() {
        loginView.endEditing(true)
        loginView.clipsToBounds = true
        loginView.backgroundColor = .white
        view.addSubview(loginView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        loginView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 100, paddingRight: 0, paddingLeft: 0, paddingBottom: bottomPadding)
        
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 1
        passwordField.tag = 2
        
        let stackview = UIStackView(arrangedSubviews: [
            usernameField, passwordField, loginButton, registerButton
            ], customSpacing: 20)
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        view.addSubview(stackview)
        stackview.setAnchor(witdh: self.view.frame.width-60
            , height: 250)
        stackview.safeBottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -bottomPadding).isActive = true
        /*stackview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true*/
        stackview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func keybowardWillChange(notification: Notification) {
        print("keyboard will show \(notification.name.rawValue)")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardSize.height
        }else{
            view.frame.origin.y = 0
        }
        
        
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
        
        view.endEditing(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
}
