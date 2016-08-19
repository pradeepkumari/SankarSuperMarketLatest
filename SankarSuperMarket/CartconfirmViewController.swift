//
//  CartconfirmViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/18/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class CartconfirmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartItemModel = [CartLineItemModel]()
    
    var individualid = [Int]()
    var cartproductid = [Int]()
    var cartname = [String]()
    var cartquantity = [String]()
    var cartprice = [String]()
    var cartDisprice = [Double]()
    var cartDispercent = [Double]()
    var cartimgurl = [String]()
    var productcartid = [Int]()
    var cartlineid = [String]()
    var modifieddate = [String]()
    var rowcount = 0
    var steppervalue = [Int]()
    var discountPrice = [String]()
    var correctdiscount = 0.0
    
    
    var name = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var country = ""
    var pincode = ""
    var mobileno = ""
    var addressid = ""
    
    var total = 0.0
    var Totalquantity = 0
    var Totaldiscountpercent: Double! = 0.0
    var cartid: String!
    var userid: String!
    
    var OrderStatusid = 1
    
    var finalamount: Double = 0.0
    var discountamount: Double = 0.0
    var subTotal: Double!
    
    @IBOutlet var namelbl: UILabel!
    
    @IBOutlet var address1lbl: UILabel!
    
    @IBOutlet var address2lbl: UILabel!
    
    @IBOutlet var citylbl: UILabel!
    
    @IBOutlet var statelbl: UILabel!
    
    @IBOutlet var countrylbl: UILabel!
    @IBOutlet var pincodelbl: UILabel!
    
    @IBOutlet var mobilenolbl: UILabel!
    
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var TotalQuantity: UILabel!
    
    @IBOutlet var TotalAmount: UILabel!
    
    @IBOutlet var TotalDiscount: UILabel!
    
    @IBOutlet var Amount: UILabel!
    
    @IBOutlet var cashbtn: UIButton!
    
    @IBOutlet var creditbtn: UIButton!
    
    @IBOutlet var debitbtn: UIButton!
    
  
   
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
         sendrequesttoserverforCartid()
        cashbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        creditbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        debitbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        tableView.delegate = self
        tableView.dataSource = self
       
        

        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        namelbl.text = name
        address1lbl.text = address1
        address2lbl.text = address2
        citylbl.text = city
        statelbl.text = state
        countrylbl.text = country
        pincodelbl.text = "Pincode - " + "\(pincode)"
        mobilenolbl.text = "Mobile No.: " + "\(mobileno)"
        Totalquantity = 0
        steppervalue.removeAll()
//        DatabaseCallforCartItems()
        sendrequesttoserverforCartItems()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("confirmCell", forIndexPath: indexPath) as UITableViewCell!
        
        let productimg = cell.viewWithTag(1) as! UIImageView
        let namelbl = cell.viewWithTag(2) as! UILabel
        let quantitylbl = cell.viewWithTag(3) as! UILabel
        let pricelbl = cell.viewWithTag(4) as! UILabel
        let productquantity = cell.viewWithTag(5) as! UILabel
        let subtotal = cell.viewWithTag(6) as! UILabel

        let productimgpath = Appconstant.IMAGEURL+"Images/Products/"+cartimgurl[indexPath.row];
        let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:productimgpath)!)!)
        productimg.image = productimages
        namelbl.text = cartname[indexPath.row]
        quantitylbl.text = cartquantity[indexPath.row]
        pricelbl.text = "\(cartDisprice[indexPath.row])"
        productquantity.text = "Qty: " + "\(steppervalue[indexPath.row])"
        
        subTotal = cartDisprice[indexPath.row] * Double(steppervalue[indexPath.row])
        subtotal.text = "SubTotal: " + "\(subTotal)"
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowcount
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    
    
    @IBAction func CashbtnAction(sender: AnyObject) {
           
        cashbtn.setImage(UIImage(named: "checked.png"), forState: .Normal)
        creditbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        debitbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
    }
    
    @IBAction func CreditbtnAction(sender: AnyObject) {
        cashbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        creditbtn.setImage(UIImage(named: "checked.png"), forState: .Normal)
        debitbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
    }
    
    
    @IBAction func DebitbtnAction(sender: AnyObject) {
        cashbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        creditbtn.setImage(UIImage(named: "unchecked.png"), forState: .Normal)
        debitbtn.setImage(UIImage(named: "checked.png"), forState: .Normal)
    }
    
    
    
    @IBAction func OrderButtonAction(sender: AnyObject) {
            
        let citymodel = CityModel.init(Name: city)!
        let statemodel = StateModel.init(Name: state)!
        let countrymodel = CountryModel.init(Name: country)!
        let contactmodel = ContactModel.init(Contactno: mobileno)!
        
        let deliveryaddress = AddressPost.init(UserID: Int(self.userid)!, ID: Int(self.addressid)!, Name: name, AddressLine1: address1, AddressLine2: address2, City: citymodel, State: statemodel, Country: countrymodel, ContactNumber: contactmodel, Pincode: Int(pincode)!)!
        
         
   
        
        for(var i = 0; i<rowcount; i++) {

        let cartadd = CartLineItemModel.init(CartID: Int(self.cartid)!, ID: Int(cartlineid[i])!, Quantity: steppervalue[i], MRP: Float(cartprice[i])!, DiscountedPrice: Double(discountPrice[i])!)!
            
            self.cartItemModel += [cartadd]
        }

        let orderviewmodel = OrderViewModel.init(BillingAddress: deliveryaddress, DeliveryAddress: deliveryaddress, CartLineItemList: self.cartItemModel, UserID: Int(self.userid)!, ID: Int(self.cartid)!, OrderStatusID: OrderStatusid, TotalPrice: finalamount)!
        
        let serializedjson  = JSONSerializer.toJson(orderviewmodel)
        
        print(serializedjson)
        sendrequesttoserverPlaceOrder(Appconstant.WEB_API+Appconstant.PLACE_ORDER, value: serializedjson)

    }
    
    
    func sendrequesttoserverPlaceOrder(url : String,value : String)
    {
        let username = "rajagcs08@gmail.com"
        let password = "1234"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
       
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
   
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
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
                    self.presentViewController(Alert().alert("Message", message: "order failed.."),animated: true,completion: nil)
                }
                else{
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
        
                }
                

        
                self.presentViewController(Alert().alert("Message", message: "Order Placed Successfully"),animated: true,completion: nil)
                
        }
        
        task.resume()
    }
    

    
    func sendrequesttoserverforCartid()
    {
        let username = "rajagcs08@gmail.com"
        let password = "1234"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        
        if supermarketDB.open() {
            let querySQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            //   while ((results.next()) == true) {
            if (results.next())
            {
                self.userid = "\(results.intForColumn("USERID"))"
                print(self.userid)
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
        
        
        
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
                self.cartid = "\(item["ID"].intValue)"
                print(self.userid)
                print(self.cartid)
              
        }
 
        task.resume()
        
    }
    
    
    func sendrequesttoserverforCartItems()
    {
        let username = "rajagcs08@gmail.com"
        let password = "1234"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        
        if supermarketDB.open() {
            let querySQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            //   while ((results.next()) == true) {
            if (results.next())
            {
                self.userid = "\(results.intForColumn("USERID"))"
                print(self.userid)
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
        
        
        
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
                var i = 0
                let json = JSON(data: data!)
                var item = json["result"]
                for item2 in item["CartLineItemList"].arrayValue{
                    self.cartlineid.append(item2["ID"].stringValue)
                    print(self.cartlineid)
                    let productvariant = item2["ProductVariant"]
                    self.cartname.append(productvariant["ProductName"].stringValue)
                    self.cartquantity.append(productvariant["Description"].stringValue)
                    self.cartDisprice.append(productvariant["DiscountPrice"].doubleValue)
                    self.cartimgurl.append(item2["ImageName"].stringValue)
                    self.productcartid.append(productvariant["ProductID"].intValue)
                    self.cartproductid.append(productvariant["ProductID"].intValue)
                    self.individualid.append(productvariant["ID"].intValue)
                    self.cartDispercent.append(productvariant["DiscountPercentage"].doubleValue)
                    self.cartprice.append(productvariant["Price"].stringValue)
                    self.discountPrice.append(productvariant["DiscountPrice"].stringValue)
                    self.steppervalue.append(item2["Quantity"].intValue)
                    print(self.steppervalue)
                    self.correctdiscount = self.correctdiscount + ((productvariant["Price"].doubleValue / 100 ) * productvariant["DiscountPercentage"].doubleValue)
                    self.discountamount = self.discountamount + (((productvariant["Price"].doubleValue / 100 ) * productvariant["DiscountPercentage"].doubleValue)) * Double(self.steppervalue[self.rowcount])
                    self.rowcount = self.rowcount + 1
                    i = i + 1
                }

                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
               
                self.Totalquantity = 0
                self.total = 0.0
                for(var i = 0; i<self.steppervalue.count; i++) {
                    self.total = self.total + (Double(self.cartprice[i])! * Double(self.steppervalue[i]))
                    self.Totalquantity = self.Totalquantity + self.steppervalue[i]
                }
                 self.TotalAmount.text = "\(self.total)"
                self.finalamount = Double(self.total) - self.discountamount
                self.TotalQuantity.text = "\(self.Totalquantity)"
                self.TotalDiscount.text = "\(self.discountamount)"
                self.Amount.text = "\(self.finalamount)"
//                self.setaddress()
                
        }
        task.resume()
    }
    func setaddress() {
        
        TotalAmount.text = "\(total)"
        Totalquantity = 0
        for(var i = 0; i<steppervalue.count; i++) {
            Totalquantity = Totalquantity + steppervalue[i]
        }
        finalamount = Double(total) - discountamount
        TotalQuantity.text = "\(Totalquantity)"
        TotalDiscount.text = "\(discountamount)"
        Amount.text = "\(finalamount)"
        
    }

}
