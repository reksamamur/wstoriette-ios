//
//  BaseListController.swift
//  wstoriette
//
//  Created by Reksa on 27/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
