//
//  OfferViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit


class OfferViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var id = [String]()
    var Description = [String]()
    var startdate = [String]()
    var expirydate = [String]()
    var couponcode = [String]()
    var username1 = ""
    var password1 = ""

    @IBOutlet weak var tableView: UITableView!
    var home: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cartbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        activityIndicator.startAnimating()
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        cartbtn.setImage(UIImage(named: "mycart_36.png"), forState: UIControlState.Normal)
        cartbtn.tintColor = UIColor.whiteColor()
        cartbtn.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        cartbtn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        //        cartbtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)

        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)

        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home
     self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        Reachability().checkconnection()
     sendrequesttoserverToGetOffer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func action(){
        self.performSegueWithIdentifier("go_home2", sender: self)
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


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as UITableViewCell!
        
        let deslbl = cell.viewWithTag(3) as! UILabel
        let startlbl = cell.viewWithTag(1) as! UILabel
        let expirylbl = cell.viewWithTag(2) as! UILabel
        let couponlbl = cell.viewWithTag(4) as! UILabel
        
        deslbl.text = Description[indexPath.row]
        startlbl.text = "From Date : " + startdate[indexPath.row]
        expirylbl.text = "To Date : " + expirydate[indexPath.row]
        couponlbl.text = "Coupon Code : " + couponcode[indexPath.row]
        activityIndicator.stopAnimating()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        return cell
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(id.count)
        return id.count
    }
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }


    func sendrequesttoserverToGetOffer()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_OFFER)!)
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
                var str = ""
                var s = ""
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
               self.id.append(item["ID"].stringValue)
                    str = item["StartDate"].stringValue
             s = str.substringWithRange(Range(start: str.startIndex.advancedBy(0), end: str.endIndex.advancedBy(-str.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet).count + 10)))

                 self.Description.append(item["Description"].stringValue)
                    self.startdate.append(s)
                    str = item["ExpiryDate"].stringValue
//                    print(str.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet).count)
//                    print(str.componentsSeparatedByString("T").count)
//                    print(str.componentsSeparatedByString("T"))
                     s = str.substringWithRange(Range(start: str.startIndex.advancedBy(0), end: str.endIndex.advancedBy(-str.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet).count + 10)))

                    self.expirydate.append(s)
                    self.couponcode.append(item["CouponCode"].stringValue)
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
        }
        task.resume()
        
    }
    
    func timeStringToDateFormat(inputString: String)-> String
    {
        
        let deFormatter = NSDateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = deFormatter.dateFromString(inputString)!
        print(inputString)
        print(startTime)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let finalDateString = formatter.stringFromDate(startTime)
        print(finalDateString)
        return finalDateString
    }

    @IBAction func CopyBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        print(indexPath.row)
        let pb: UIPasteboard = UIPasteboard.generalPasteboard();
        pb.string = couponcode[indexPath.row]
//        let snackbar: TTGSnackbar = TTGSnackbar.init(message: "Coupon code copied", duration: 2)
        self.presentViewController(Alert().alert("Coupon code copied", message: ""),animated: true,completion: nil)
    }
    
    

}
