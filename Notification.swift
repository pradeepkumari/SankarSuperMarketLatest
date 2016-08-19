//
//  Notification.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class Notification {
    var Title: String
    var Description: String
    var StartDate: String
    var NotificationPhoto:UIImage?
    // MARK: Initialization
    
    init?(Title: String ,Description: String, StartDate: String, NotificationPhoto: UIImage) {
        // Initialize stored properties.
        self.Title = Title
        self.Description = Description
        self.StartDate = StartDate
        self.NotificationPhoto = NotificationPhoto
    }
}