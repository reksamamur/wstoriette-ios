//
//  CAlert.swift
//  wstoriette
//
//  Created by Reksa on 11/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class CAlert {
    
    func initalert(on vc: UIViewController, with tittle: String, message: String) {
        let aler = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        aler.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(aler, animated: true, completion: nil)
        }
    }
    
    func initalertDismiss(on vc: UIViewController, with tittle: String, message: String) {
        let aler = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        aler.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            vc.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
            vc.present(aler, animated: true, completion: nil)
        }
    }
    
    func initalertDismissNav(on vc: UIViewController, with tittle: String, message: String) {
        let aler = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        aler.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            vc.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            vc.present(aler, animated: true, completion: nil)
        }
    }
    
    func initalertExit(on vc: UIViewController, with tittle: String, message: String) {
        let aler = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        aler.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            exit(0)
        }))
        DispatchQueue.main.async {
            vc.present(aler, animated: true, completion: nil)
        }
    }
    
    func initalertDoLogin(on vc: UIViewController, with tittle: String, message: String) {
        let aler = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        aler.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            let doLogin = LoginViewController()
            vc.present(doLogin, animated: true)
        }))
        DispatchQueue.main.async {
            vc.present(aler, animated: true, completion: nil)
        }
    }
}
