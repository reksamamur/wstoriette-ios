//
//  RegistrationViewController.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    let regisView = UIView()
    private var currentTextField: UITextField?
    
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
    
    let nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.placeholder = "Name"
        field.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        field.layer.borderWidth = 1.5
        field.layer.cornerRadius = 5
        field.autocorrectionType = .no
        field.setAnchor(witdh: 0, height: 50)
        field.setLeftPaddingPoint(20)
        return field
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.placeholder = "Email"
        field.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        field.layer.borderWidth = 1.5
        field.layer.cornerRadius = 5
        field.autocorrectionType = .no
        field.keyboardType = UIKeyboardType.emailAddress
        field.setAnchor(witdh: 0, height: 50)
        field.setLeftPaddingPoint(20)
        return field
    }()
    
    let usernameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.placeholder = "Username"
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
        field.placeholder = "Password"
        field.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        field.layer.borderWidth = 1.5
        field.layer.cornerRadius = 5
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.setAnchor(witdh: 0, height: 50)
        field.setLeftPaddingPoint(20)
        return field
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
        btn.addTarget(self, action: #selector(handleRegis), for: .touchUpInside)
        return btn
    }()
    
    var username: String?
    var password: String?
    var nameUser: String?
    var emailUser: String?
    
    @objc func handleRegis(){
        self.username = usernameField.text
        self.password = passwordField.text
        self.nameUser = nameField.text
        self.emailUser = emailField.text
        
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty || nameField.text!.isEmpty || emailField.text!.isEmpty{
            let alert = CAlert()
            alert.initalert(on: self, with: "Please input these field", message: "Please dont let these field empty")
        }else{
            print("\(self.username ?? "") + \(self.password ?? "")")
            
            fetchUser(username: username ?? "", password: password ?? "", email: emailUser ?? "", name: nameUser ?? "")
            let goLogin = LoginViewController()
            present(goLogin, animated: true)
        }
    }
    
    func setupView() {
        regisView.endEditing(true)
        regisView.clipsToBounds = true
        regisView.backgroundColor = .white
        view.addSubview(regisView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        regisView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 100, paddingRight: 0, paddingLeft: 0, paddingBottom: bottomPadding)
        
        usernameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
        nameField.delegate = self
        
        
        let stackview = UIStackView(arrangedSubviews: [
            nameField, emailField, usernameField, passwordField, registerButton
            ], customSpacing: 20)
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        view.addSubview(stackview)
        stackview.setAnchor(witdh: self.view.frame.width-60
            , height: 0)
        stackview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func fetchUser(username: String, password: String, email: String, name: String) {
        let post_url_string = "https://storiette-api.azurewebsites.net/regUser"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("username=\(username)&password=\(password)&email=\(email)&name=\(name)").data(using: .utf8)
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, err) in
            DispatchQueue.main.async {
                print("finish fetching 2")
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    let result = try jDecoder.decode(UserRegisResult.self, from: data)
                    print("status regis \(result.status)")
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalertDismissNav(on: self, with: "Woopss something wrong", message: "we don't know yet")
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    self.nameField.text = ""
                    self.emailField.text = ""
                }
            }
            }.resume()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupClosebtn()
        setupView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        /*NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybowardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)*/
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
