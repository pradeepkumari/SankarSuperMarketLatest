//
//  NoticeViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
     var notificationItems = [Notification]()
    var username1 = ""
    var password1 = ""
    
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
  
    var home: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.userInteractionEnabled = false
        activityIndicator.startAnimating()
        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home
        // Do any additional setup after loading the view, typically from a nib.
        sendrequesttoserver();
        self.view.userInteractionEnabled = true
        activityIndicator.stopAnimating()
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

    func action(){
        self.performSegueWithIdentifier("fromnotice_tohome", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "noticeCell"
        let noticecell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell!
        let notice = notificationItems[indexPath.row]
        
        let noticeimg = noticecell.viewWithTag(1) as! UIImageView
        let noticelbl = noticecell.viewWithTag(2) as! UILabel
        noticelbl.text = notice.Title
        noticeimg.image = notice.NotificationPhoto
        
        noticecell.layer.borderWidth = 0.5
        noticecell.layer.borderColor = UIColor.grayColor().CGColor

        
        return noticecell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationItems.count
    }

    
    

    func sendrequesttoserver()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GETNOTICE)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        //         NSURLProtocol.setProperty("application/json", forKey: "Content-Type", inRequest: request)
        //        NSURLProtocol.setProperty(base64LoginString, forKey: "Authorization", inRequest: request)
        //        NSURLProtocol.setProperty(AppConstants.TENANT, forKey: "TENANT", inRequest: request)
        //
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
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
                    print(item["ID"].stringValue)
                    let NotificationimgPath = Appconstant.IMAGEURL+"Images/Notice/"+item["ImagePath"].stringValue;
                    let nimg = UIImage(data: NSData(contentsOfURL: NSURL(string:NotificationimgPath)!)!)
                    let notification = Notification(Title: item["Title"].stringValue, Description: item["Description"].stringValue, StartDate: item["StartDate"].stringValue,  NotificationPhoto : nimg!)!
                    
                    self.notificationItems += [notification];
                }
                
                dispatch_async(dispatch_get_main_queue()) {
           
                    self.tableView.reloadData()
                   
                }
        }
        task.resume()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_nextnotice") {
          
            let nextviewcontroller = segue.destinationViewController as! NextnoticeViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            nextviewcontroller.noticeimg = self.notificationItems[(indexPath?.row)!].NotificationPhoto
            nextviewcontroller.noticenamelbl = self.notificationItems[(indexPath?.row)!].Title
            nextviewcontroller.noticedescriptionlbl = self.notificationItems[(indexPath?.row)!].Description
            nextviewcontroller.noticedatelbl = self.notificationItems[(indexPath?.row)!].StartDate
             
        }
        
    }
    


}
