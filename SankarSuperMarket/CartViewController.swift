//
//  CartViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryID = ""
    var imglist: [UIImage] = []
    var cname = [String]()
    var cquantity = [String]()
    var cprice = [String]()
    var imgurl = [String]()
    var cproductid = [Int]()
    var cid = [Int]()
    var clineid = [Int]()
    var total = 0.0
    var rowcount = 0
    var steppervalue = [Int]()
     var stepvalue = 1
    var mulvalue = 1.0
    var cartlineid = ""
    var servercartid = 0
    var userid = ""
    var id = [Int]()
    var noofItems = [Int]()
    var mrp = [Double]()
    var disprice = [Double]()
    var btnvalue = 0
    var username1 = ""
    var password1 = ""

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var toplabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var totallbl: UILabel!
    var home: UIBarButtonItem!
   
    @IBOutlet weak var checkoutbutton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        getuserdetails()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.tableView.dataSource = self
        self.tableView.delegate = self
        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home
        sideBarButton.target = revealViewController()
        sideBarButton.action = Selector("revealToggle:")
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Reachability().checkconnection()
        sendrequesttoserverforCartid()
        
    }
    func action(){
        self.performSegueWithIdentifier("gohome_fromcart", sender: self)
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
        self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"
        let cartcell = tableView.dequeueReusableCellWithIdentifier("CCell", forIndexPath: indexPath) as UITableViewCell!
        
        
        let productimg = cartcell.viewWithTag(1) as! UIImageView
        let namelbl = cartcell.viewWithTag(2) as! UILabel
        let quantitylbl = cartcell.viewWithTag(3) as! UILabel
        let pricelbl = cartcell.viewWithTag(4) as! UILabel
        let changevaluelbl = cartcell.viewWithTag(5) as! UILabel


        

      //  checker[indexPath.row] = steppervalue[indexPath.row]
        print(indexPath.row)
        let productimgpath = Appconstant.IMAGEURL+"Images/Products/"+imgurl[indexPath.row];
        let productimages =  UIImage(data: NSData(contentsOfURL: NSURL(string:productimgpath)!)!)
        productimg.image = productimages
        changevaluelbl.text = "\(steppervalue[indexPath.row])"
        namelbl.text = cname[indexPath.row]
        quantitylbl.text = cquantity[indexPath.row]
        let no = Double(cprice[indexPath.row])!
        mulvalue = no * Double(steppervalue[indexPath.row])
        pricelbl.text = "\u{20B9}" + cprice[indexPath.row] + " " + "x" + " " + "\(steppervalue[indexPath.row])" +  " " + "=" + " " +  "\(mulvalue)"
        cartcell.layer.borderWidth = 0.5
        cartcell.layer.borderColor = UIColor.grayColor().CGColor
        activityIndicator.stopAnimating()
        return cartcell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tabBarItem.badgeValue = "\(self.rowcount)"
        return rowcount
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    
    

    func sendrequesttoserver(url : String,value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        //    let events = EventManager();
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        // set Content-Type in HTTP header
        
        //         NSURLProtocol.setProperty("application/json", forKey: "Content-Type", inRequest: request)
        //        NSURLProtocol.setProperty(base64LoginString, forKey: "Authorization", inRequest: request)
        //        NSURLProtocol.setProperty(AppConstants.TENANT, forKey: "TENANT", inRequest: request)
        //
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        //    let postString `= "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    Reachability().checkconnection()
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                    
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
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            

 
                self.sendrequesttoserverfordeletecartItem("\(self.clineid[indexPath.row])")
                self.cname.removeAll()
                self.cquantity.removeAll()
                self.cprice.removeAll()
                self.imgurl.removeAll()
                self.cproductid.removeAll()
                self.clineid.removeAll()
                self.rowcount = 0
                self.total = 0
                Reachability().checkconnection()
                self.sendrequesttoserverforCartid()
        }
        let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController?.addAction(action)
        alertController?.addAction(action1)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
        
        
    }

    
    func sendrequesttoserverfordeletecartItem(value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.REMOVE_CART_LINEITEM+value)!)
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
    
    
 

    
    
    @IBAction func checkoutAction(sender: AnyObject) {
        self.performSegueWithIdentifier("cartTOaddress", sender: self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "cartTOaddress") {
            let nextview = segue.destinationViewController as! AddressViewController
            nextview.seguevalue = "Fromcart"
            nextview.passSteppervalue = self.steppervalue
            nextview.total = self.total
        }
    }
    
    func sendrequesttoserverforCartid()
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
                self.cartlineid.removeAll()
                self.cname.removeAll()
                self.mrp.removeAll()
                self.cquantity.removeAll()
                self.cprice.removeAll()
                self.imgurl.removeAll()
                self.cproductid.removeAll()
                self.cid.removeAll()
                self.steppervalue.removeAll()
                self.disprice.removeAll()
                self.total = 0
                self.rowcount = 0
                let json = JSON(data: data!)
                var item = json["result"]
                self.servercartid = item["ID"].intValue
                for item2 in item["CartLineItemList"].arrayValue{
                    self.clineid.append(item2["ID"].intValue)
                    let productvariant = item2["ProductVariant"]
                    self.cname.append(productvariant["ProductName"].stringValue)
                    self.mrp.append(productvariant["Price"].doubleValue)
                    self.cquantity.append(productvariant["Description"].stringValue)
                    self.cprice.append(productvariant["DiscountPrice"].stringValue)
                    self.imgurl.append(item2["ImageName"].stringValue)
                    self.cproductid.append(productvariant["ProductID"].intValue)
                    self.cid.append(productvariant["ID"].intValue)
                    self.steppervalue.append(item2["Quantity"].intValue)
                    self.disprice.append(item2["DiscountedPrice"].doubleValue)
                    self.total = self.total + (Double(self.cprice[self.rowcount])! * Double(self.steppervalue[self.rowcount]))
                    
                    print("cprice==>>",self.cprice[self.rowcount])
                    print("stepperval==>>",self.steppervalue[self.rowcount])
                    print("total==>>",self.total)
                    self.rowcount = self.rowcount + 1
                    print ("Quantity Count==>>",self.rowcount)

                }
    
               dispatch_async(dispatch_get_main_queue()) {
            self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"
//             self.totallbl.text = String(item["TotalPrice"].doubleValue)
            self.tableView.reloadData()
        }
         
                
    }

      task.resume()
        
    }
    
//    func assignvalue(){
//         self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"
//        if(self.rowcount == 0) {
//            
//            totallbl.text = " " + "  " + "Total \u{20B9}\(0.0)"
//        }
//        else {
//            self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"
//        }
//        
//    }
    
    
    @IBAction func PlusBtnAction(sender: AnyObject) {
        Reachability().checkconnection()
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        print(indexPath)
        btnvalue = steppervalue[indexPath.row]
         steppervalue[indexPath.row] = steppervalue[indexPath.row] + 1
            self.tableView.reloadData()
            let productvariantmodel = Productvariantmodel.init(ID: cid[indexPath.row], ProductID: cproductid[indexPath.row])!
            let cartupdate = CartupdateViewModel.init(CartID: servercartid, ID: clineid[indexPath.row], Quantity: steppervalue[indexPath.row], MRP: mrp[indexPath.row], DiscountedPrice: disprice[indexPath.row], ProductVariant: productvariantmodel)!
            let serializedjson  = JSONSerializer.toJson(cartupdate)
            print(serializedjson)
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.UPDATE_CART_LINEITEM, value: serializedjson)
        self.total = self.total + (Double(self.cprice[indexPath.row])!)
        self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"
    }
    
    @IBAction func MinusBtnAction(sender: AnyObject) {
        Reachability().checkconnection()
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        print(indexPath)
        if(steppervalue[indexPath.row] > 1){
            steppervalue[indexPath.row] = steppervalue[indexPath.row] - 1
            self.tableView.reloadData()
            let productvariantmodel = Productvariantmodel.init(ID: cid[indexPath.row], ProductID: cproductid[indexPath.row])!
            let cartupdate = CartupdateViewModel.init(CartID: servercartid, ID: clineid[indexPath.row], Quantity: steppervalue[indexPath.row], MRP: mrp[indexPath.row], DiscountedPrice: disprice[indexPath.row], ProductVariant: productvariantmodel)!
            let serializedjson  = JSONSerializer.toJson(cartupdate)
            print(serializedjson)
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.UPDATE_CART_LINEITEM, value: serializedjson)
            self.total = self.total - (Double(self.cprice[indexPath.row])!)
            self.totallbl.text = " " + "  " + "Total \u{20B9}\(self.total)"

        }
        else if(steppervalue[indexPath.row] == 1){
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Are you sure want to delete?",
                message: "",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
                print(self.clineid[indexPath.row])
                
                self.sendrequesttoserverfordeletecartItem("\(self.clineid[indexPath.row])")

                self.sendrequesttoserverforCartid()
            }
            let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
            }
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!,
                animated: true,
                completion: nil)

        }
        
    }
    
    
    
}



