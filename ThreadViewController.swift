////
////  ThreadViewController.swift
////  SankarSuperMarket
////
////  Created by Admin on 7/9/16.
////  Copyright © 2016 vertaceapp. All rights reserved.
////
//
import UIKit
//
class ThreadViewController: UIViewController {
//    var threadname = [String]()
//    var threadid = [String]()
//    var threadlabel = [String]()
//    var thread = ""
//    var userid = ""
//    var message = ""
//    var msgqueue = [String]()
//    var singlethreadid = ""
//    
//    @IBOutlet weak var tableView: UITableView!
// 
//    var alertController:UIAlertController?
//    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getThreadNamefromServer()
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
////        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        
    }
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let selectionColor = UIView() as UIView
//        selectionColor.layer.borderWidth = 1
//        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
//        selectionColor.backgroundColor = UIColor.clearColor()
//        cell.selectedBackgroundView = selectionColor
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let threadcell = tableView.dequeueReusableCellWithIdentifier("threadCell", forIndexPath: indexPath) as UITableViewCell!
//        singlethreadid = threadid[indexPath.row]
////        sendrequesttoserverforGetMessage()
//        let threadTitle = threadcell.viewWithTag(1) as! UILabel
//        let threadsubtitle = threadcell.viewWithTag(2) as! UILabel
//        threadTitle.text = threadname[indexPath.row]
//        threadsubtitle.text = msgqueue[indexPath.row]
//        threadcell.layer.borderWidth = 0.5
//        threadcell.layer.borderColor = UIColor.grayColor().CGColor
//        return threadcell
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return threadname.count
//    }
//
//
//    
//    
//    @IBAction func createThreadBtnAction(sender: AnyObject) {
//
//        
//        var alertController:UIAlertController?
//        alertController = UIAlertController(title: "New Chat Thread",
//            message: "",
//            preferredStyle: .Alert)
//        
//        alertController!.addTextFieldWithConfigurationHandler(
//            {(textField: UITextField!) in
//                textField.placeholder = "Thread Title"
//        })
//
//        let action = UIAlertAction(title: "Ok",
//            style: UIAlertActionStyle.Default,
//            handler: {[weak self]
//                (paramAction:UIAlertAction!) in
//                if let textFields = alertController?.textFields{
//                    let theTextFields = textFields as [UITextField]
//                    let enteredText = theTextFields[0].text
//                    self!.thread = enteredText!
//                    print(self!.thread)
//                    self!.getuserid()
//                    let usermodel = UserModel.init(ID: self!.userid)!
//                    let threadviewmodel = ThreadViewModel.init(User: usermodel, ThreadTitle: self!.thread)!
//                    let serializedjson  = JSONSerializer.toJson(threadviewmodel)
//                    print(serializedjson)
//                    self!.CreateThreadinServer(Appconstant.WEB_API+Appconstant.NEW_MESSAGE_THREAD, value: serializedjson)
//                }
//            })
//        let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
//            
//        }
//
//        alertController?.addAction(action)
//        alertController?.addAction(action1)
//        self.presentViewController(alertController!,
//            animated: true,
//            completion: nil)
//
//    }
//    func getThreadNamefromServer(){
//        
//        let username = "rajagcs08@gmail.com"
//        let password = "1234"
//        let loginString = NSString(format: "%@:%@", username, password)
//        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//        
//        getuserid()
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_MESSAGE_THREAD+self.userid)!)
//        request.HTTPMethod = "GET"
//        // set Content-Type in HTTP header
//        
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
//        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
//        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
//        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        //     print("GET RESPONSE")
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
//            { data, response, error in
//                guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                    print("ERROR")
//                    print("response = \(response)")
//                    return
//                }
//                
//                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(response)")
//                }
//                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                //     print("responseString = \(responseString)")
//                let json = JSON(data: data!)
//                for item in json["result"].arrayValue {
//                    self.threadid.append(item["ID"].stringValue)
//                    self.threadname.append(item["ThreadTitle"].stringValue)
//                    var i: Int = 0
//                    for items in item["MessageList"].arrayValue{
//                        i = 1
//                        self.message = items["MessageContent"].stringValue
//                        print(self.message)
//                        print(items["MessageContent"].stringValue)
//                    }
//                    if(i == 1){
//                    self.msgqueue.append(self.message)
//                    }
//                    else {
//                        self.msgqueue.append("")
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.tableView.reloadData()
//                }
//                
//        }
//        
//        task.resume()
//
//    }
//    func CreateThreadinServer(url : String,value : String){
//        let username = "rajagcs08@gmail.com"
//        let password = "1234"
//        let loginString = NSString(format: "%@:%@", username, password)
//        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//        //    let events = EventManager();
//        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
//        
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//        request.HTTPMethod = "Post"
//        // set Content-Type in HTTP header
//        
//        //         NSURLProtocol.setProperty("application/json", forKey: "Content-Type", inRequest: request)
//        //        NSURLProtocol.setProperty(base64LoginString, forKey: "Authorization", inRequest: request)
//        //        NSURLProtocol.setProperty(AppConstants.TENANT, forKey: "TENANT", inRequest: request)
//        //
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
//        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
//        
//      
//        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
//            { data, response, error in
//                guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                    
//                    return
//                }
//                
//                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(response)")
//                }
//                
//                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                print("responseString = \(responseString)")
//                self.threadid.removeAll()
//                self.threadname.removeAll()
//                self.getThreadNamefromServer()
//        }
//        task.resume()
//    }
//
//
//    func getuserid(){
//        DBHelper().opensupermarketDB()
//        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
//        let databasePath = databaseURL.absoluteString
//        let supermarketDB = FMDatabase(path: databasePath as String)
//        
//        if supermarketDB.open() {
//            let querySQL = "SELECT * FROM LOGIN"
//            
//            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
//                withArgumentsInArray: nil)
//            //   while ((results.next()) == true) {
//            if (results.next())
//            {
//               userid = "\(results.intForColumn("USERID"))"
//                print(userid)
//                
//            }
//            supermarketDB.close()
//        } else {
//            print("Error: \(supermarketDB.lastErrorMessage())")
//        }
//        
//
//    }
//    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "goto_messages") {
//            let indexPath = self.tableView.indexPathForSelectedRow
//            let nextview = segue.destinationViewController as! MessageViewController
//            nextview.threadid = threadid[(indexPath?.row)!]
//            
//        }
//    }
//   
// 
//}
