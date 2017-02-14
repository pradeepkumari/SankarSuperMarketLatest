//
//  ImageViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var albumid = [String]()
    var albumname = [String]()
    var imgurl = [String]()
    var id = ""
    var home: UIBarButtonItem!
    var username1 = ""
    var password1 = ""
    @IBOutlet weak var collectionView: UICollectionView!
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        self.tabBarController?.tabBar.hidden = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
                home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
                navigationItem.rightBarButtonItem = home
        sideBarButton.target = revealViewController()
        sideBarButton.action = Selector("revealToggle:")

        activityIndicator.startAnimating()

        checkconnection()
        sendrequesttoserver()
    }
    func checkconnection(){
        if Reachability.isConnectedToNetwork() == true {
            //            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "No Internet",
                message: "Check network connection",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.checkconnection()
            }
            let action1 = UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                exit(0)
            }
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!,
                animated: true,
                completion: nil)
            
        }
        
    }

    func getuserdetails(){
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            
            let selectSQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
                withArgumentsInArray: nil)
            if (results.next())
            {
                
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func action(){
        self.performSegueWithIdentifier("go_home0", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return albumid.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("folderCell", forIndexPath: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let textLabel = cell.viewWithTag(2) as! UILabel
         textLabel.text = albumname[indexPath.row]
        if(indexPath.row == 1){
            img.image = UIImage(named: "loading_sqr.png")
            return cell
        }
        let imgpath = Appconstant.IMAGEURL+"Images/Gallery/"+self.imgurl[indexPath.row]
//        let images =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
        if let data = NSData(contentsOfURL: NSURL(string:imgpath)!){
            let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:imgpath)!)!)
            img.image = productimages
        }
        else{
            let productimages = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
            img.image = productimages
        }

        self.view.userInteractionEnabled = true
        activityIndicator.stopAnimating()
        return cell
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.row == 1){
            return true
        }
        else {
        id = albumid[indexPath.row]
        }
//        self.performSegueWithIdentifier("goto_images", sender: self)
        return true
    }

    
    func sendrequesttoserver()
    {
        print(self.username1)
        print(self.password1)
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_ALBUM)!)
        print(request)
        print(base64LoginString)
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
                  self.albumid.append(item["ID"].stringValue)
                  self.albumname.append(item["Name"].stringValue)
                }
                for(var i = 0; i<self.albumid.count - 1; i++){

                    self.checkconnection()
                    self.sendrequesttoserverforImages(Appconstant.WEB_API+Appconstant.GET_IMAGES+self.albumid[i])
                }
                
        }
        task.resume()
        
    }
    func sendrequesttoserverforImages(url : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var i = 0
                for items in json["result"].arrayValue {
                    if(i == 0){
                        print(items["FilePath"].stringValue)
                self.imgurl.append(items["FilePath"].stringValue)
                        
                        i = 1
                }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
        }
        
        task.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_images") {
            let nextviewcontroller = segue.destinationViewController as! ViewPhoto
            nextviewcontroller.albumid = id
            nextviewcontroller.username1 = self.username1
            nextviewcontroller.password1 = self.password1
           
        }
    }



}
