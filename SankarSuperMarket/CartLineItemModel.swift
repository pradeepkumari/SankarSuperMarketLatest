//
//  CartLineItemModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/29/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class CartLineItemModel{
    var CartID: Int
    var ID: Int
    var Quantity: Int
    var MRP: Float
    var DiscountedPrice: Double
    init?(CartID: Int, ID: Int, Quantity: Int, MRP: Float, DiscountedPrice: Double) {
        self.CartID = CartID
        self.ID = ID
        self.Quantity = Quantity
        self.MRP = MRP
        self.DiscountedPrice = DiscountedPrice
    }
}


