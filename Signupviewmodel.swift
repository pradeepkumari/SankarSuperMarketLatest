//
//  Signupviewmodel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class Signupviewmodel
{
    var Name : String
    var EmailID : String
    var PhoneNumber : String
    var Password : String
    
    init?( Name : String, EmailID : String, PhoneNumber : String, Password : String)
    {
        self.Name = Name
        self.EmailID = EmailID
        self.PhoneNumber = PhoneNumber
        self.Password = Password
    }
    
    
}