//
//  Category.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
class Category {
    
    var ID: String
    var Name: String
    var CategoryPhoto:UIImage?
    // MARK: Initialization
    
    init?(ID: String, Name: String, CategoryPhoto: UIImage) {
        // Initialize stored properties.
        self.ID = ID
        self.Name = Name
        self.CategoryPhoto = CategoryPhoto
        
        // Initialization should fail if there is no name or if the rating is negative.
        
    }

    
}