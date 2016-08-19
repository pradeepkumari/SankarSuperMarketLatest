//
//  NextnoticeViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/10/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class NextnoticeViewController: UIViewController {
    
    var noticenamelbl = ""
    var noticedescriptionlbl = ""
    var noticedatelbl = ""
    var noticeimg: UIImage?
    
    
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var startdate: UILabel!

    @IBOutlet weak var descripe: UILabel!

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.tintColor = UIColor.blueColor()
//        toplabel.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view, typically from a nib.
       
        name.text = self.noticenamelbl
        img.image = self.noticeimg
        startdate.text = "Start Date : " + self.noticedatelbl
        descripe.text = self.noticedescriptionlbl

               
    }
}
