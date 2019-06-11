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
}
