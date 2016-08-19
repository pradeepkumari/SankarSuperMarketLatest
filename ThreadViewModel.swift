//
//  ThreadViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/11/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class ThreadViewModel {
    var User: UserModel
    var ThreadTitle: String
    init?(User: UserModel, ThreadTitle: String){
        self.User = User
        self.ThreadTitle = ThreadTitle
    }

}

class UserModel{
    var ID: String
    init?(ID: String){
        self.ID = ID
    }
}