//
//  PopViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 9/20/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    var userid = ""
    var username1 = ""
    var password1 = ""
    var weekname = [String]()
    var monthname = [String]()
    var weekid = [Int]()
    var monthid = [Int]()
    var weekbtnselected = true

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var weekBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.frame.size.height = 90
        self.tableView.frame.size.height = 0
        tableView.registerNib(UINib(nibName: "RecurringTableViewCell", bundle: nil), forCellReuseIdentifier: "RecurringCell")
        getuserdetails()
        self.sendrequesttoserver()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
            }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecurringTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecurringCell", forIndexPath: indexPath) as! RecurringTableViewCell
        let namelbl = cell.viewWithTag(1) as! UILabel
        if(weekbtnselected == true){
        namelbl.text = weekname[indexPath.row]
        }
        else{
             namelbl.text = monthname[indexPath.row]
        }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Appconstant.bgcolor.CGColor
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(weekbtnselected == true){
            self.view.frame.size.height = CGFloat(90 + (45 * weekid.count))
            self.tableView.frame.size.height = CGFloat(45 * weekid.count)
            return weekid.count
        }
        self.view.frame.size.height = CGFloat(90 + (45 * monthid.count))
        self.tableView.frame.size.height = CGFloat(45 * monthid.count)
        return monthid.count

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Are you sure want to delete?",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in

        if(self.weekbtnselected == true){
            print(self.weekid[indexPath.row])
            let recurring = RecurringViewModel.init(productID: Appconstant.productid, productVariantID: Appconstant.productvariantid, recurringOrderID: self.weekid[indexPath.row])!
            let serializedjson  = JSONSerializer.toJson(recurring)
            print(serializedjson)
            self.AddLineItemtoRecurringOrder(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST, value: serializedjson)

        }
        else{
            let recurring = RecurringViewModel.init(productID: Appconstant.productid, productVariantID: Appconstant.productvariantid, recurringOrderID: self.monthid[indexPath.row])!
            let serializedjson  = JSONSerializer.toJson(recurring)
            print(serializedjson)
            self.AddLineItemtoRecurringOrder(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST, value: serializedjson)

        }
        }
        let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController?.addAction(action)
        alertController?.addAction(action1)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)

        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
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
//                self.userid = "\(results.intForColumn("USERID"))"
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                print(results.stringForColumn("EMAILID"))
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
        
    }
    func sendrequesttoserver()
    {
        let username = self.username1
        let password = self.password1

        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_RECURRING_NAME+"117")!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    self.presentViewController(Alert().alert("No network", message: "Check internet connection"),animated: true,completion: nil)
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    self.presentViewController(Alert().alert("No network", message: "Check internet connection"),animated: true,completion: nil)
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                

                let json = JSON(data: data!)
                    for item in json["result"].arrayValue {
                        if(item["SelectedDates"].stringValue != ""){
                            self.monthid.append(item["ID"].intValue)
                            self.monthname.append(item["Name"].stringValue)
                            
                        }
                        else if(item["SelectedDays"].stringValue != "") {
                            self.weekid.append(item["ID"].intValue)
                            self.weekname.append(item["Name"].stringValue)
                        }
                 
                        
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
        }
        task.resume()
        
    }

    func AddLineItemtoRecurringOrder(url : String,value : String){
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
        
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
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
       
        }
        task.resume()
    }


    
    @IBAction func WeekBtnAction(sender: AnyObject) {
        weekbtnselected = true
        self.tableView.reloadData()
    }
    
    @IBAction func MonthBtnAction(sender: AnyObject) {
        weekbtnselected = false
        self.tableView.reloadData()
    }
    
    
    
    
    @IBAction func CloseBtn(sender: AnyObject) {
        self.dismissPopupViewController(.Fade)
    }
 
    @IBAction func AddBtn(sender: AnyObject) {

    }
    

}
