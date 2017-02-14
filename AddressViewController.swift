//
//  AddressViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var rowcount = 0
    var name = [String]()
    var address1 = [String]()
    var address2 = [String]()
    var city = [String]()
    var state = [String]()
    var country = [String]()
    var pincode = [String]()
    var mobileno = [String]()
    var id = [String]()
    var addressids = [String]()
    var seguevalue = ""
    var passSteppervalue = [Int]()
    var total = 0.0
    
    var cityid = [String]()
    var stateid = [String]()
    var countryid = [String]()
    var contactid = [String]()
    var userid = ""
    var addressid = [String]()
    var path = 0
    var username1 = ""
    var password1 = ""

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        

    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getuserdetails()
        name.removeAll()
        address1.removeAll()
        address2.removeAll()
        city.removeAll()
        state.removeAll()
        country.removeAll()
        pincode.removeAll()
        mobileno.removeAll()
        rowcount = 0
        checkconnection()
        getaddressid()
        getAddressFromServer()
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
        let acell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as UITableViewCell!
        let namelbl = acell.viewWithTag(1) as! UILabel
        let addr1lbl = acell.viewWithTag(2) as! UILabel
        let addr2lbl = acell.viewWithTag(3) as! UILabel
        let citylbl = acell.viewWithTag(4) as! UILabel
        let statelbl = acell.viewWithTag(5) as! UILabel
        let countrylbl = acell.viewWithTag(6) as! UILabel
        let pincodelbl = acell.viewWithTag(7) as! UILabel
        let mobilenolbl = acell.viewWithTag(8) as! UILabel
        namelbl.text = name[indexPath.row]
        addr1lbl.text = address1[indexPath.row]
        addr2lbl.text = address2[indexPath.row]
        statelbl.text = state[indexPath.row]
        citylbl.text = city[indexPath.row]
        countrylbl.text = country[indexPath.row]
        pincodelbl.text = pincode[indexPath.row]
        mobilenolbl.text = mobileno[indexPath.row]
        acell.layer.borderWidth = 1
        acell.layer.borderColor = Appconstant.bgcolor.CGColor
        activityIndicator.stopAnimating()
        return acell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  rowcount
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if(self.seguevalue == "Fromcart") {
            
            self.performSegueWithIdentifier("goto_confirm", sender: self)
        }
    }
//    func addressdatabasecall() {
//        
//        DBHelper().opensupermarketDB()
//        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
//        let databasePath = databaseURL.absoluteString
//        let supermarketDB = FMDatabase(path: databasePath as String)
//        rowcount = 0
//        if supermarketDB.open() {
//            let querySQL = "SELECT * FROM ADDRESS"
//            
//            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
//                withArgumentsInArray: nil)
//            
//                while(results.next()) {
//                    id.append(results.stringForColumn("ID"))
//                    addressids.append((results.stringForColumn("ADDRESSID"))!)
//                name.append((results.stringForColumn("NAME"))!)
//                address1.append((results.stringForColumn("ADDRESS1"))!)
//                address2.append((results.stringForColumn("ADDRESS2"))!)
//                city.append((results.stringForColumn("CITY"))!)
//                state.append((results.stringForColumn("STATE"))!)
//                country.append((results.stringForColumn("COUNTRY"))!)
//                pincode.append((results.stringForColumn("PINCODE"))!)
//                mobileno.append((results.stringForColumn("MOBILENO"))!)
//
//                    print(pincode)
//                    print(mobileno)
//                    print(addressids)
//                rowcount = rowcount + 1
//             }
//            supermarketDB.close()
//            self.tableView.reloadData()
//        
//        }
//        
//        else {
//            print("Error: \(supermarketDB.lastErrorMessage())")
//        }
//
//    }

    
    @IBAction func EditBtnAction(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        path = indexPath.row
    }
    

    @IBAction func DeleteButton(sender: AnyObject) {
    
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Are you sure want to delete?",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in

            self.name.removeAll()
            self.address1.removeAll()
            self.address2.removeAll()
            self.city.removeAll()
            self.state.removeAll()
            self.country.removeAll()
            self.pincode.removeAll()
            self.mobileno.removeAll()
            let username = self.username1
            let password = self.password1
            let loginString = NSString(format: "%@:%@", username, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.ADDRESS_DELETE+self.addressid[indexPath.row])!)
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
                    self.getAddressFromServer()
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
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_confirm") {
            let indexPath = self.tableView.indexPathForSelectedRow
            let nextview = segue.destinationViewController as! ConfirmViewController
            nextview.steppervalue = self.passSteppervalue
            nextview.name = self.name[(indexPath?.row)!]
            nextview.address1 = self.address1[(indexPath?.row)!]
            nextview.address2 = self.address2[(indexPath?.row)!]
            nextview.city = self.city[(indexPath?.row)!]
            nextview.state = self.state[(indexPath?.row)!]
            nextview.country = self.country[(indexPath?.row)!]
            nextview.pincode = self.pincode[(indexPath?.row)!]
            nextview.mobileno = self.mobileno[(indexPath?.row)!]
            nextview.total = self.total
            nextview.addressid = self.addressids[(indexPath?.row)!]
        }
        if(segue.identifier == "from_edit"){
            let nextview = segue.destinationViewController as! EditaddressViewController
            nextview.addressid = self.addressids[path]
            nextview.name = self.name[path]
            nextview.address1 = self.address1[path]
            nextview.address2 = self.address2[path]
            nextview.city = self.city[path]
            nextview.state = self.state[path]
            nextview.country = self.country[path]
            nextview.pincode = self.pincode[path]
            nextview.mobileno = self.mobileno[path]
            nextview.edit = 1
            
        }
        
    }
    
    func getaddressid(){
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.ADDRESS_OPEN+userid)!)
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
                let json = JSON(data: data!)
                
                for items in json["result"].arrayValue {
                self.addressid.append(items["ID"].stringValue)
                }
        }
        
        
        
        task.resume()
        
        
    }
    
 
    func getAddressFromServer() {
        
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.ADDRESS_OPEN+userid)!)
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
                self.name.removeAll()
                self.address1.removeAll()
                self.address2.removeAll()
                self.city.removeAll()
                self.state.removeAll()
                self.country.removeAll()
                self.pincode.removeAll()
                self.mobileno.removeAll()
                self.rowcount = 0
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
                    
                    self.addressids.append(item["ID"].stringValue)
                    self.name.append(item["Name"].stringValue)
                    self.address1.append(item["AddressLine1"].stringValue)
                    self.address2.append(item["AddressLine2"].stringValue)
                    self.pincode.append(item["Pincode"].stringValue)
                    let value = item["City"]
                    self.city.append(value["Name"].stringValue)
                    let value1 = item["State"]
                    self.state.append(value1["Name"].stringValue)
                    let value2 = item["Country"]
                    self.country.append(value2["Name"].stringValue)
                    let value3 = item["ContactNumber"]
                    self.mobileno.append(value3["ContactNo"].stringValue)
                    self.rowcount = self.rowcount + 1
                }
                print(self.addressids)
                

                dispatch_async(dispatch_get_main_queue()) {
                    if(self.rowcount == 0){
                        self.activityIndicator.stopAnimating()
                        self.presentViewController(Alert().alert("No address found", message: ""),animated: true,completion: nil)
                    }
                    self.tableView.reloadData()
                }
        }
        
        task.resume()

        
    }

    
}
