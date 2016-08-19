//
//  PagelistViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/30/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class PagelistViewModel {
    var OrderByColumn: String
    var OrderByType: String
    var Productname: String
    var pageSize: Int
    var categoryID: Int
    var pageNumber: Int
    init?(OrderByColumn: String, OrderByType: String, Productname: String, pageSize: Int, categoryID: Int, pageNumber: Int){
    
        self.OrderByColumn = OrderByColumn
        self.OrderByType = OrderByType
        self.Productname = Productname
        self.pageSize = pageSize
        self.categoryID = categoryID
        self.pageNumber = pageNumber
    }

 
}
