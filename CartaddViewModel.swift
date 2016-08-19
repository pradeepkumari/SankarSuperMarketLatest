//
//  CartaddViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/28/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class CartaddViewModel {
    
    var CartID: Int
    var ProductVariant: Productvariant
    var Quantity: Int
    var MRP: Float
    var DiscountedPrice: Float
    init?(CartID: Int, ProductVariant: Productvariant, Quantity: Int, MRP: Float, DiscountedPrice: Float) {
        self.CartID = CartID
        self.ProductVariant = ProductVariant
        self.Quantity = Quantity
        self.MRP = MRP
        self.DiscountedPrice = DiscountedPrice
    }
}
class Productvariant {
    var ID: Int
    var ProductID: Int
    var ProductName: String
    var Stock: Int
    var Description: String
    var Unit: String
    var Quantity: Int
    var Price: Float
    var DiscountPercentage: Float
    var DiscountPrice: Float
    init?(ID: Int, ProductID: Int, ProductName: String, Stock: Int, Description: String, Unit: String, Quantity: Int, Price: Float, DiscountPercentage: Float, DiscountPrice: Float) {
        self.ID = ID
        self.ProductID = ProductID
        self.ProductName = ProductName
        self.Stock = Stock
        self.Description = Description
        self.Unit = Unit
        self.Quantity = Quantity
        self.Price = Price
        self.DiscountPercentage = DiscountPercentage
        self.DiscountPrice = DiscountPrice
        
    }
}

    

