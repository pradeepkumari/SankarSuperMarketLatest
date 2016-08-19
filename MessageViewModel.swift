//
//  MessageViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/11/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class MessageViewModel {
    
    var Sender: UserModel1
    var MessageContent: String
    var messageThreadID: String
    init?(Sender: UserModel1, MessageContent: String, messageThreadID: String){
        self.Sender = Sender
        self.MessageContent = MessageContent
        self.messageThreadID = messageThreadID
    }
}

class UserModel1{
    var ID: String
    init?(ID: String){
        self.ID = ID
    }
}