//
//  ApplyCouponModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 8/26/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ApplyCouponModel: NSObject {
    var ID: Int
    var OfferCouponCode: String
    
    init?(ID: Int, OfferCouponCode: String)
    {
        self.ID = ID
        self.OfferCouponCode = OfferCouponCode
        
    }
}
