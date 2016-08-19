//
//  ViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var signin: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        signup.layer.cornerRadius = 5
        signin.layer.cornerRadius = 5
    }
}

