//
//  SubmitOTP.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/5/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class SubmitOTP {
    var EmailID: String
    var OTP: String
    var PhoneNumber: String
    var Password: String
    init?(EmailID: String, OTP: String, PhoneNumber: String, Password: String){
        self.EmailID = EmailID
        self.OTP = OTP
        self.PhoneNumber = PhoneNumber
        self.Password = Password        
    }
}
