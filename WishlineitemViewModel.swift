//
//  WishlineitemViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/15/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class WishlineitemViewModel {
    var productVariantID: Int
    var productID: Int
    var wishlistID: String
    init?(productVariantID: Int, productID: Int, wishlistID: String){
        self.productVariantID = productVariantID
        self.productID = productID
        self.wishlistID = wishlistID
    }

}
