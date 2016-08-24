//
//  SingleimgViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class SingleimgViewController: UIViewController {
    
    var imagelist = [String]()
    var indexpath = 0
    var albumid = ""
    var count = 0
    @IBOutlet weak var img: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.imagelist[indexpath]

        let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)

        img.image = images
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right :
                
                indexpath = indexpath - 1
                if(indexpath<0){
                    indexpath = count - 1
                }
                let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.imagelist[indexpath]
                
                let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                img.image = images
//                img.image = self.imagelist[indexpath]
  
            case UISwipeGestureRecognizerDirection.Left:
                
                indexpath = indexpath + 1
                if(indexpath == count){
                    indexpath = 0
                }
                let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.imagelist[indexpath]
                
                let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                img.image = images
//                img.image = self.imagelist[indexpath]
                
            default:
                break
                
                
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "back_to_images") {
            let nextviewcontroller = segue.destinationViewController as! ViewPhoto
//            nextviewcontroller.imagelist = self.imagelist
            nextviewcontroller.albumid = self.albumid
            
        }
    }

    
}
