//
//  DecrementViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/29/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class DecrementViewModel {
    var userId: String
    var productId: Int
    var productVariantId: Int
    init?(userId: String, productId: Int, productVariantId: Int){
        self.userId = userId
        self.productId = productId
        self.productVariantId = productVariantId
    }

}
