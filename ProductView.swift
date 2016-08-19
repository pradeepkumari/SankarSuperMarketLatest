


//
//  ProductView.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/27/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class ProductView {
    var pageSize : Int
    var categoryID: String
    init?(pageSize : Int, categoryID: String){
        self.pageSize = pageSize
        self.categoryID = categoryID
    }
   
}
