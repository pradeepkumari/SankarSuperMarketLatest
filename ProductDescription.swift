//
//  ProductDescription.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/9/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ProductDescription {
    
    var Productname: String
    var Description: String
    var Price: String
    var Discount: String
    var OfferAmount: String
    var Unit: String
    var Type: String
    var Quantiyt: String
    
    // MARK: Initialization
    
    init?(Productname: String ,Description: String, Price: String,Discount: String, OfferAmount: String, Unit: String, Type: String, Quantity: String ) {
        // Initialize stored properties.
        self.Productname = Productname
        self.Description = Description
        self.Price = Price
        self.Discount = Discount
        self.OfferAmount = OfferAmount
        self.Unit = Unit
        self.Type = Type
        self.Quantiyt = Quantity
        
    }
}
