//
//  WriteFinishViewController.swift
//  wstoriette
//
//  Created by Reksa on 13/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class WriteFinishViewController: UIViewController, UITextViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
