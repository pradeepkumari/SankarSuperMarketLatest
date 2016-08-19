//
//  ViewPhoto.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ViewPhoto: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var albumid = ""
    var indexpath = 0
    var albumimage = [String]()
    var imagelist = [UIImage]()
    var albumid1 = ""
    var username1 = ""
    var password1 = ""

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        albumid1 = albumid

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        albumimage.removeAll()
        Reachability().checkconnection()
        sendrequesttoserver()
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listCell", forIndexPath: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.albumimage[indexPath.row]
        print(imgpath)
        let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
//        imagelist.append(images!)
        img.image = images

        return cell
    }
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(albumimage.count)
        return albumimage.count
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        indexpath = indexPath.row
//        self.performSegueWithIdentifier("goto_imageview", sender: self)
        return true
    }


func sendrequesttoserver()
{
    let username = self.username1
    let password = self.password1
    let loginString = NSString(format: "%@:%@", username, password)
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    
    //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
    print(self.albumid)
    
    let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_IMAGES+self.albumid1)!)
    request.HTTPMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
    request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
    
    
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            let json = JSON(data: data!)
            for item in json["result"].arrayValue {

                self.albumimage.append(item["FilePath"].stringValue)
                print(item["FilePath"].stringValue)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
    }
    task.resume()
    
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_imageview") {
            let nextviewcontroller = segue.destinationViewController as! SingleimgViewController
                nextviewcontroller.imagelist = self.albumimage
                nextviewcontroller.albumid = self.albumid
                nextviewcontroller.indexpath = indexpath
                nextviewcontroller.count = albumimage.count
        }
    }


}