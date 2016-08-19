//
//  ProfileViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/12/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class ProfileViewModel {
    var EmailID: String
    var Password: String
    init?(EmailID: String, Password: String){
        self.EmailID = EmailID
        self.Password = Password
    }

}
