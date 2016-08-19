//
//  CartViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/27/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class CartViewModel{
    var UserID: Int
    var ProductVariant: Array<ProductVariantModel>
    var Quantity: String
    var MRP: String
    var DiscountPrice: String
    var ModifiedDateTime: String
    init?(UserID: Int, ProductVariant: Array<ProductVariantModel>, Quantity: String, MRP: String, DiscountPrice: String, ModifiedDateTime: String)
    {
        self.UserID = UserID
        self.ProductVariant = ProductVariant
        self.Quantity = Quantity
        self.MRP = MRP
        self.DiscountPrice = DiscountPrice
        self.ModifiedDateTime = ModifiedDateTime
    }
}


class ProductVariantModel{
    var ID: Int
    var ProductID: Int
    var ProductName: String
    var Stock: String
    var Description: String
    var UnitID: String
    var Unit: String
    var Quantity: String
    var Price: String
    var DiscountPercentage: String
    var DiscountPrice: String
    init?(ID: Int, ProductID: Int, ProductName: String, Stock: String, Description: String, UnitID: String, Unit: String, Quantity: String,Price: String, DiscountPercentage: String, DiscountPrice: String)
    {
        self.ID = ID
        self.ProductID = ProductID
        self.ProductName = ProductName
        self.Stock = Stock
        self.Description = Description
        self.UnitID = UnitID
        self.Unit = Unit
        self.Quantity = Quantity
        self.Price = Price
        self.DiscountPercentage = DiscountPercentage
        self.DiscountPrice = DiscountPrice
    }
}