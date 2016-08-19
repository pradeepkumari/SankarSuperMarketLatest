//
//  CartupdateViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/20/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class CartupdateViewModel {
    var CartID: Int
    var ID: Int
    var Quantity: Int
    var MRP: Double
    var DiscountedPrice: Double
    var ProductVariant: Productvariantmodel
    init?(CartID: Int, ID: Int, Quantity: Int, MRP: Double, DiscountedPrice: Double, ProductVariant: Productvariantmodel) {
        self.CartID = CartID
        self.ID = ID
        self.Quantity = Quantity
        self.MRP = MRP
        self.DiscountedPrice = DiscountedPrice
        self.ProductVariant = ProductVariant
  }
}
class Productvariantmodel{
    var ID: Int
    var ProductID: Int
    init?(ID: Int, ProductID: Int){
        self.ID = ID
        self.ProductID = ProductID
    }
}