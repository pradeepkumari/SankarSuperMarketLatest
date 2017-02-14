//
//  MovetocartViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/14/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class MovetocartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var wishlistLineid = ""
    var wishlistname=""
    var listids = [String]()
    var image = [String]()
    var name = [String]()
    var discountprice = [String]()
    
    var individualid = [Int]()
    var productid = [Int]()
    var quantity = [String]()
    var price = [String]()
    var discountpercent = [Double]()
    var discountprice1 = [Double]()
    var cartlineid = [Int]()
    var userid = ""
    var id = [Int]()
    var count = 0
    var username1 = ""
    var password1 = ""
    var cartcountnumber = 0
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var movetocartButton: UIButton!
    
    @IBOutlet weak var cartBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = wishlistname
        self.cartBtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartBtn.layer.cornerRadius = 23
        self.cartBtn.layer.shadowOpacity = 1
        self.cartBtn.layer.shadowRadius = 2
        self.cartBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartBtn.layer.shadowColor = UIColor.grayColor().CGColor
        self.cartBtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        cartBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        
        cartBtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
 
        cartBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)
        cartBtn.tintColor = UIColor.whiteColor()
        cartBtn.backgroundColor = Appconstant.btngreencolor
        cartBtn.titleLabel?.textColor = Appconstant.btngreencolor
//        cartBtn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        //        cartbtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        cartBtn.userInteractionEnabled = true
        cartBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartBtn)

        
        getuserdetails()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        checkconnection()
        getWishListItems()
        
        
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
                self.userid = "\(results.intForColumn("USERID"))"
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("movecartCell", forIndexPath: indexPath) as UITableViewCell!
        let img = cell.viewWithTag(1) as! UIImageView
        let namelbl = cell.viewWithTag(2) as! UILabel
        let pricelbl = cell.viewWithTag(3) as! UILabel
        
        let productimgpath = Appconstant.IMAGEURL+"Images/Products/"+image[indexPath.row];
//        let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:productimgpath)!)!)
        if let data = NSData(contentsOfURL: NSURL(string:productimgpath)!){
            let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:productimgpath)!)!)
            img.image = productimages
        }
        else{
            let productimages = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
            img.image = productimages
        }
        namelbl.text = name[indexPath.row]
        pricelbl.text = "\u{20B9}" + discountprice[indexPath.row]
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Appconstant.bgcolor.CGColor
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listids.count
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    func getWishListItems() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_ALL_WISHLIST_LINEITEM+wishlistLineid)!)
        request.HTTPMethod = "GET"
      
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                     print("responseString = \(responseString)")
                
                let json = JSON(data: data!)
                let items = json["result"]
                for item in items["wishlistLineItemDTOs"].arrayValue {
                    self.listids.append(item["ID"].stringValue)
                    let item1 = item["productDTO"]

                        self.name.append(item1["Name"].stringValue)
                        self.image.append(item1["ImageUrl"].stringValue)
                    
                    let item2 = item["WishListproductVariant"]
                    self.discountprice.append(String(item2["DiscountPrice"].doubleValue))
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    if(self.name.count == 0){
                        self.movetocartButton.hidden = true
                    }
                    else{
                        self.movetocartButton.hidden = false
                    self.tableView.reloadData()
                    }
                }
                
        }
        
        task.resume()

    }
    
    @IBAction func MoveToCartBtnAction(sender: AnyObject) {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Are you sure want to move to cart?",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
        self.checkconnection()
        self.cartcountnumber += self.listids.count
        self.cartBtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.MOVE_TO_CART+self.wishlistLineid)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    print("Error")
                }
                else{
                     self.presentViewController(Alert().alert("Added to cart", message: ""),animated: true,completion: nil)
                }
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                     print("responseString = \(responseString)")
                
                let json = JSON(data: data!)
                let items = json["result"]
                for item in items["wishlistLineItemDTOs"].arrayValue {
                    let item2 = item["WishListproductVariant"]
                    self.individualid.append(item2["ID"].intValue)
                    self.productid.append(item2["ProductID"].intValue)
                    self.quantity.append(item2["Description"].stringValue)
                    self.price.append(String(item2["Price"].doubleValue))
                    self.discountpercent.append(item2["DiscountPercentage"].doubleValue)
                    self.discountprice1.append(item2["DiscountPrice"].doubleValue)
                    
                }
//                self.GetCartLineid()
               
        }
        
        task.resume()
        }
        let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController?.addAction(action)
        alertController?.addAction(action1)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
        

    }
    

    
    
    func GetCartLineid()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //     print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var item = json["result"]
                for items in item["CartLineItemList"].arrayValue {
                    self.id.append(items["ID"].intValue)
                }
                print(self.id)
                self.count = self.id.count - 1
                print(self.count)
//                self.inserintoDatabase()
        }
        task.resume()
    }
    
    @IBAction func DeleteBtnAction(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        print(indexPath.row)
        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Are you sure want to delete?",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let username = self.username1
            let password = self.password1
            let loginString = NSString(format: "%@:%@", username, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.DELETE_WISH_LIST_LINEITEM+self.listids[indexPath.row])!)
            request.HTTPMethod = "GET"
            // set Content-Type in HTTP header
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
            request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
            //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
            //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            //     print("GET RESPONSE")
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                { data, response, error in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        print("ERROR")
                        print("response = \(response)")
                        return
                    }
                    
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //     print("responseString = \(responseString)")
                    self.listids.removeAll()
                    self.name.removeAll()
                    self.image.removeAll()
                    self.discountprice.removeAll()
                    let json = JSON(data: data!)
                    let items = json["result"]
                    for item in items["wishlistLineItemDTOs"].arrayValue {
                        self.listids.append(item["ID"].stringValue)
                        let item1 = item["productDTO"]
                        
                        self.name.append(item1["Name"].stringValue)
                        self.image.append(item1["ImageUrl"].stringValue)
                        
                        let item2 = item["WishListproductVariant"]
                        self.discountprice.append(String(item2["DiscountPrice"].doubleValue))
                        
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    
            }
            
            task.resume()
        }
        let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController?.addAction(action)
        alertController?.addAction(action1)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
        
      

        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "goto_product2") {
//            let nextviewcontroller = segue.destinationViewController as! ProductdetailViewController
//            let indexPath = self.tableView.indexPathForSelectedRow
//            
//            
//            nextviewcontroller.productimage =
//            nextviewcontroller.productname =
//            nextviewcontroller.prodesc =
//            nextviewcontroller.proprice =
//            nextviewcontroller.prodiscount =
//            nextviewcontroller.proamount =
//            nextviewcontroller.prounit =
//            nextviewcontroller.protype =
//            nextviewcontroller.proquantity =
//            nextviewcontroller.individuvalid =
//            nextviewcontroller.productid =
//            nextviewcontroller.dis_price =
//            nextviewcontroller.cartid = self.cartid
//            nextviewcontroller.username1 = self.username1
//            nextviewcontroller.password1 = self.password1
//            
//            
//        }
//    }

    
}
