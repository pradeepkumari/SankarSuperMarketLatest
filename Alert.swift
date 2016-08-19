//
//  Alert.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class Alert :UIViewController{
    func alert(title: String,message: String)-> UIAlertController
    {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
}
