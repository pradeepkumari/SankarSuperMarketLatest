//
//  ResendOTP.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/5/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class ResendOTP{
    var EmailID: String
    var PhoneNumber: String
    init?(EmailID: String, PhoneNumber: String){
        self.EmailID = EmailID
        self.PhoneNumber = PhoneNumber
    }

}
