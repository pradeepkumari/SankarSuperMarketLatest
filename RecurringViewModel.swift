//
//  RecurringViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 9/21/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class RecurringViewModel {

    var productID: Int
    var productVariantID: Int
    var recurringOrderID: Int
    init?(productID: Int, productVariantID: Int, recurringOrderID: Int){
        self.productID = productID
        self.productVariantID = productVariantID
        self.recurringOrderID = recurringOrderID
    }

}
