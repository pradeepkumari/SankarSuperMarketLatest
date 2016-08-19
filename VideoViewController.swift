//
//  VideoViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController{


    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var pageController: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipeRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwipeLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
       
    }

    func handleSwipeLeft(gesture: UISwipeGestureRecognizer){
        if self.pageController.currentPage < 3 {
            self.pageController.currentPage += 1
            lbl.text = "left" + "\(self.pageController.currentPage)"
        }
    }
    
    // reduce page number on swift right
    func handleSwipeRight(gesture: UISwipeGestureRecognizer){
        
        if self.pageController.currentPage != 0 {
            self.pageController.currentPage -= 1
            lbl.text = "right" + "\(self.pageController.currentPage)"
        }

    }
}