//
//  OrderViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var orderid = [String]()
    var amount = [String]()
    var date = [String]()
    
    var userid = ""
    var username1 = ""
    var password1 = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.startAnimating()
        checkconnection()
        gethistory()
        tableView.delegate = self
        tableView.dataSource = self
        
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

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ordercell =  tableView.dequeueReusableCellWithIdentifier("orderCell", forIndexPath: indexPath) as UITableViewCell!
        
        let orderlbl = ordercell.viewWithTag(1) as! UILabel
        let amountlbl = ordercell.viewWithTag(2) as! UILabel
        let paylbl = ordercell.viewWithTag(3) as! UILabel
        let datelbl = ordercell.viewWithTag(4) as! UILabel
        orderlbl.text = "ORD/" + "\(orderid[indexPath.row])"
        amountlbl.text = amount[indexPath.row]
        paylbl.text = "Cash on Delivery"
        datelbl.text = date[indexPath.row]
        
        ordercell.layer.borderWidth = 1
        ordercell.layer.borderColor = UIColor.whiteColor().CGColor
        activityIndicator.stopAnimating()
        return ordercell
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderid.count
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {        
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    
    func gethistory(){
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.ORDER_HISTORY+userid)!)
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
//                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                
                for items in json["result"].arrayValue {
                    self.orderid.append(items["ID"].stringValue)
                    self.amount.append(items["TotalPrice"].stringValue)
                    
                    let str = items["OrderDateTime"].stringValue
                    
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
//                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                    let value1 = dateFormatter.dateFromString(item["Date"].stringValue)
//                    let value2 = dateFormatter.dateFromString(item["RequestStartTime"].stringValue)
//                    let value3 = dateFormatter.dateFromString(item["RequestEndTime"].stringValue)
//                    
//                    
//                    dateFormatter.dateFormat = "dd/M/yyyy"///this is you want to convert format
//                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
//                    let value11 = dateFormatter.stringFromDate(value1!)

                    let s = str.substringWithRange(Range(start: str.startIndex.advancedBy(0), end: str.endIndex.advancedBy(-str.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet).count + 10)))
                    
                    self.date.append(s)

                }
                dispatch_async(dispatch_get_main_queue()) {
                    if(self.orderid.count == 0){
                        self.activityIndicator.stopAnimating()
                        self.presentViewController(Alert().alert("Order history not found", message: ""),animated: true,completion: nil)
                    }
                    self.tableView.reloadData()
                }
        }
        
        task.resume()
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_reorder") {
    
                let indexPath = self.tableView.indexPathForSelectedRow
                let nextview = segue.destinationViewController as! ReorderViewController
                nextview.cartid = orderid[(indexPath?.row)!]
            
        }
    }

    
}
