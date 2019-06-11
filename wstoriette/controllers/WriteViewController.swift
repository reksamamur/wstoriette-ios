//
//  WriteViewController.swift
//  wstoriette
//
//  Created by Reksa on 01/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController, UITextViewDelegate {
    
    let textField: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.text = "Write down here"
        tv.textColor = .lightGray
        return tv
    }()
    
    var textTemp: String!
    
    func checkLogin() {
        let statuss = UserDefaults.standard.bool(forKey: "status")
        if statuss == false {
            textField.isEditable = false
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
        }else{
            textField.isEditable = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavButton()
        setupWritePanel()
        checkLogin()
    }
    
    func setupWritePanel() {
        view.addSubview(textField)
        textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        textField.translatesAutoresizingMaskIntoConstraints = false
        [
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: view.frame.height)
        ].forEach{$0.isActive = true}
        textField.fillSuperview(padding: .init(top: 0, left: 15, bottom: 15, right: 15 ))
        textField.delegate = self
        self.textTemp = textField.text
    }
    
    func setupNavButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(actionLeftBtnSave))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(actionRightBtnSave))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textTemp = textView.text
        print(textView.text)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatesize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                 constraint.constant = estimatesize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textTemp = textView.text
        if textView.text == "Write down here" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "/n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textTemp = textView.text
        if textView.text == "" {
            textView.text = "Write down here"
            textView.textColor = .lightGray
        }
    }
    
    @objc func actionLeftBtnSave() {
        print("Cancel")
        self.view.endEditing(true)
    }
    
    @objc func actionRightBtnSave() {
        print("Next")
        self.view.endEditing(true)
        print("\(textTemp ?? "")")
        if textTemp == "Write down here" {
            print("kosong")
        }
    }
}
