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

//        let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
        if let data = NSData(contentsOfURL: NSURL(string:imgpath)!){
            let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
            img.image = productimages
        }
        else{
            let productimages = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
            img.image = productimages
        }
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
                
//                let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                var images: UIImage?
                if let data = NSData(contentsOfURL: NSURL(string:imgpath)!){
                     images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                    img.image = images
                }
                else{
                     images = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                    img.image = images
                }
               
  
            case UISwipeGestureRecognizerDirection.Left:
                
                indexpath = indexpath + 1
                if(indexpath == count){
                    indexpath = 0
                }
                let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.imagelist[indexpath]
                
//                let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                if let data = NSData(contentsOfURL: NSURL(string:imgpath)!){
                    let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
                    img.image = productimages
                }
                else{
                    let productimages = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                    img.image = productimages
                }
                
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
