
//
//  RoughViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 9/16/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class RoughViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ShowBtn(sender: AnyObject) {
        self.removeFromParentViewController()
//        self.dismissViewControllerAnimated(true) { () -> Void in
//            
//                    }
    }

}
