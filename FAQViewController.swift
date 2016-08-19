//
//  FAQViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var question = [String]()
    var answer = [String]()
    var row = 0
    var username1 = ""
    var password1 = ""
    var home: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        activityIndicator.startAnimating()
        self.tabBarController?.tabBar.hidden = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        Reachability().checkconnection()
        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home
        sendrequesttoserver()

        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    func action(){
        self.performSegueWithIdentifier("go_home3", sender: self)
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("faqCell", forIndexPath: indexPath) as UITableViewCell!
        
        let questionlbl = cell.viewWithTag(1) as! UILabel
        let answerlbl = cell.viewWithTag(2) as! UILabel
        let nolbl = cell.viewWithTag(3) as! UILabel
        nolbl.text = "\(indexPath.row + 1)" + "."
        questionlbl.text = question[indexPath.row]
        answerlbl.text = " " + answer[indexPath.row]
//        answerlbl.hidden = true
         self.tableView.rowHeight = UITableViewAutomaticDimension
//        if(row == indexPath.row){
//            answerlbl.hidden = false
//             self.tableView.rowHeight = UITableViewAutomaticDimension
//        }
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.grayColor().CGColor
        activityIndicator.stopAnimating()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        row = indexPath.row
        self.tableView.reloadData()
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    func sendrequesttoserver()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.FAQ_ALL)!)
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
                self.question.append(item["Question"].stringValue)
                self.answer.append(item["Answer"].stringValue)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
               
        }
        task.resume()
        
    }

}
