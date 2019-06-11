//
//  UserDefault.swift
//  wstoriette
//
//  Created by Reksa on 11/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class UserDefault {
    var success: String = ""
    let uDefault = UserDefaults.standard
    
    struct Keys {
        static let successLoginKey = "successLogin"
    }
    
    func saveSucces(success: String) {
        self.success = success
        uDefault.set(success, forKey: Keys.successLoginKey)
    }
}
