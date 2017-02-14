//
//  ViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    
    @IBOutlet weak var signin: UIButton!
   
    @IBOutlet weak var signup: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        signup.layer.cornerRadius = 17
        signin.layer.cornerRadius = 17
        
        signup.backgroundColor = Appconstant.btngreencolor
        signin.backgroundColor = Appconstant.btngreencolor
        
        navigationController?.navigationBar.hidden = true
//        self.cartbtn.layer.shadowOpacity = 1
//        self.cartbtn.layer.shadowRadius = 2
//        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
//        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor

    }
}

