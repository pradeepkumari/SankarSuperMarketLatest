//
//  OrderViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/29/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class OrderViewModel {
    var BillingAddress: AddressPost
    var DeliveryAddress: AddressPost
    var CartLineItemList: Array<CartLineItemModel>
    var UserID: Int
    var ID: Int
    var OrderStatusID: Int
    var TotalPrice: Double
    
    init?(BillingAddress: AddressPost, DeliveryAddress: AddressPost,CartLineItemList: Array<CartLineItemModel>, UserID: Int, ID: Int, OrderStatusID: Int, TotalPrice: Double){
        self.BillingAddress = BillingAddress
        self.DeliveryAddress = DeliveryAddress
        self.CartLineItemList = CartLineItemList
        self.UserID = UserID
        self.ID = ID
        self.OrderStatusID = OrderStatusID
        self.TotalPrice = TotalPrice
    }
    

  

}
