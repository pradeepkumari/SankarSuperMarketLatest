//
//  CategoryProduct.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/9/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
class CategoryProduct {
    
    var ID: String
    var Name: String
    var Description : String
    var ProductPhoto:UIImage?
    var Productimgurl: String
    var ProductvariantList: Array<ProductVariantList>
    // MARK: Initialization
    
    init?(ID: String, Name: String, Description : String, ProductPhoto: UIImage, Productimgurl: String, ProductvariantList: Array<ProductVariantList>) {
        // Initialize stored properties.
        self.ID = ID
        self.Name = Name
        self.Description = Description
        self.ProductPhoto = ProductPhoto
        self.Productimgurl = Productimgurl
        self.ProductvariantList = ProductvariantList
        
        // Initialization should fail if there is no name or if the rating is negative.
        
    }
    
    
}
class ProductVariantList {
    var ID: Int
    var ProductID: Int
    var ProductName: String
    var Price: String
    var DiscountPercentage: String
    var DiscountPrice: String
    var Unit: String
    var Type: String
    var Quantity: String
    var Stock: String
    var UnitID: String
    var cartCount: Int
    // MARK: Initialization
    
    init?(ID: Int, ProductID: Int, ProductName: String, Price: String, Stock: String, DiscountPercentage: String, DiscountPrice: String, Unit: String, Type: String, Quantity: String, UnitID: String, cartCount: Int) {
        // Initialize stored properties.
        self.ID = ID
        self.ProductID = ProductID
        self.ProductName = ProductName
        self.Price = Price
        self.Stock = Stock
        self.DiscountPercentage = DiscountPercentage
        self.DiscountPrice = DiscountPrice
        self.Unit = Unit
        self.Type = Type
        self.Quantity = Quantity
        self.UnitID = UnitID
        self.cartCount = cartCount
        // Initialization should fail if there is no name or if the rating is negative.
        
    }
    
    
}