//
//  ReorderViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/19/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ReorderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartid = ""
    var productname = [String]()
    var type = [String]()
    var quantity = [Int]()
    var price = [Double]()
    var subtotal = [Double]()
    var userid = ""
    
    var subquantity = [Int]()
    var subDiscountprice = [Double]()
    var totalamount = 0.0
    var discountamount = 0.0
    var price1 = 0.0
    var subdiscountprice1 = 0.0
    @IBOutlet var namelbl: UILabel!
    
    @IBOutlet var address1lbl: UILabel!
    
    @IBOutlet var address2lbl: UILabel!
    
    @IBOutlet var citylbl: UILabel!
    
    @IBOutlet var statelbl: UILabel!
    
    @IBOutlet var countrylbl: UILabel!
    @IBOutlet var pincodelbl: UILabel!
    
    @IBOutlet var mobilenolbl: UILabel!
    
    
    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var TotalQuantity: UILabel!
    
    @IBOutlet var TotalAmount: UILabel!
    
    @IBOutlet var TotalDiscount: UILabel!
    
    @IBOutlet var Amount: UILabel!
    
    @IBOutlet weak var reorder: UIButton!
    
    
    var totalquantity = 0.0
    var totalamount1 = 0.0
    var totaldiscount = 0.0
    var amount1 = 0.0
    var username1 = ""
    var password1 = ""
    var cartcountnumber = 0
    
    @IBOutlet var cashbtn: UIButton!
    var imagename = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        reorder.layer.cornerRadius = 3
 
        cashbtn.setImage(UIImage(named: "checked.png"), forState: .Normal)
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        
        cartbtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        cartbtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
        cartbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)
        cartbtn.tintColor = UIColor.whiteColor()
        cartbtn.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
//        cartbtn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        //        cartbtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)
        
        tableView.delegate = self
        tableView.dataSource = self
        Reachability().checkconnection()
        getOrderHistoryUsingCartid()
        
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cartcountnumber = 0
        Getcartcount()
        reorder.layer.cornerRadius = 5
        reorder.layer.borderWidth = 1
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reorderCell", forIndexPath: indexPath) as UITableViewCell!
        
        let productimg = cell.viewWithTag(1) as! UIImageView
        let namelbl = cell.viewWithTag(2) as! UILabel
        let quantitylbl = cell.viewWithTag(3) as! UILabel
        let pricelbl = cell.viewWithTag(4) as! UILabel
        let productquantity = cell.viewWithTag(5) as! UILabel
        let subtotal = cell.viewWithTag(6) as! UILabel
        
        namelbl.text = productname[indexPath.row]
        quantitylbl.text = type[indexPath.row]
        pricelbl.text = "\(price[indexPath.row])"
        productquantity.text = "Qty: " + "\(subquantity[indexPath.row])"
        subtotal.text = "SubTotal: " + "\(subDiscountprice[indexPath.row])"
        let productimgpath = Appconstant.IMAGEURL+"Images/Products/"+imagename[indexPath.row];
        let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:productimgpath)!)!)
        productimg.image = productimages

        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productname.count
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }

    func getOrderHistoryUsingCartid(){
        
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
 
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_ALL_CART_LINEITEM+self.cartid)!)
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
                let item = json["result"]
                let item1 = item["DeliveryAddress"]
                let city = item1["City"]
               
                let state = item1["State"]
                 let country = item1["Country"]
                
                let contactno = item1["ContactNumber"]
                
                for item2 in item["CartLineItemList"].arrayValue{
                    let productvariant = item2["ProductVariant"]
                    self.productname.append(productvariant["ProductName"].stringValue)
                    self.type.append(productvariant["Description"].stringValue)
                    self.price.append(productvariant["DiscountPrice"].doubleValue)
                    
                    self.subquantity.append(item2["Quantity"].intValue)
                    self.subtotal.append(item2["DiscountedPrice"].doubleValue)
                    self.subDiscountprice.append(item2["DiscountedPrice"].doubleValue)
                    self.price1 = productvariant["Price"].doubleValue
                    self.subdiscountprice1 = item2["DiscountedPrice"].doubleValue
                    self.totalamount = self.totalamount + (productvariant["Price"].doubleValue * item2["Quantity"].doubleValue)
                    self.discountamount = self.discountamount + (item2["DiscountedPrice"].doubleValue * item2["Quantity"].doubleValue)
                    self.imagename.append(item2["ImageName"].stringValue)
                    
                    self.totalquantity = self.totalquantity + item2["Quantity"].doubleValue
                }
        
               
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.TotalQuantity.text = "\(self.totalquantity)"
                    self.TotalAmount.text = "\(self.totalamount)"
                    self.Amount.text = "\(self.discountamount)"
                    self.totaldiscount = self.totalamount - self.discountamount
                    self.TotalDiscount.text = "\(self.totaldiscount)"
                    self.namelbl.text = item1["Name"].stringValue
                    self.address1lbl.text = item1["AddressLine1"].stringValue
                    self.address2lbl.text = item1["AddressLine2"].stringValue
                    self.pincodelbl.text = "Pincode:" + "\(item1["Pincode"].stringValue)"
                    self.citylbl.text = "\(city["Name"].stringValue)"
                    self.statelbl.text = "\(state["Name"].stringValue)"
                    self.countrylbl.text = "\(country["Name"].stringValue)"
                    self.mobilenolbl.text = "Mobile No:" + "\(contactno["ContactNo"].stringValue)"

                    self.tableView.reloadData()
                }

                
        }
        
        
        task.resume()
    }

    
    @IBAction func ReorderBtnAction(sender: AnyObject) {
        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Are you sure want to reorder?",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            Reachability().checkconnection()
            self.cartcountnumber += self.productname.count
            self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.REORDER_PRODUCT+self.cartid)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
    
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
    
    func Getcartcount() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
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
                
                
                let json = JSON(data: data!)
                var item = json["result"]
                for item2 in item["CartLineItemList"].arrayValue{
                    
                    self.cartcountnumber = self.cartcountnumber + 1
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
                }
        }
        
        task.resume()
        
    }

    

}
