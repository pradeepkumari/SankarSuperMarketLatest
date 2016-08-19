//
//  MessageViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/9/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITextFieldDelegate  {
    var threadid = ""
    var text = ""
    var userid = ""
    var messagequeue = [String]()
    var id = [Int]()
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var textfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        print(self.threadid)
        textfield.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        sendrequesttoserverforGetMessage()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let msgcell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as UITableViewCell!
        let senderlbl = msgcell.viewWithTag(2) as! UILabel
        let receiverlbl = msgcell.viewWithTag(1) as! UILabel
        
        
        if(id[indexPath.row] == 0) {
            receiverlbl.hidden = false
            receiverlbl.text = " " + messagequeue[indexPath.row] + " "
            receiverlbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
            receiverlbl.numberOfLines = 5
            
            senderlbl.hidden = true
        }
        else {
            senderlbl.hidden = false
            senderlbl.text = " " + messagequeue[indexPath.row] + " "
            senderlbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
            senderlbl.numberOfLines = 5
            receiverlbl.hidden = true
        }
        

        return msgcell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id.count
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == textfield) {
            animateViewMoving(true, moveValue: 200)
        }

        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == textfield) {
            animateViewMoving(false, moveValue: 200)
        }

    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func sendrequesttoserverforGetMessage()
    {
        let username = "rajagcs08@gmail.com"
        let password = "1234"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
     
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_MESSAGE_THREAD_ID+threadid)!)
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
//                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                     print("responseString = \(responseString)")
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
                    self.messagequeue.append(item["MessageContent"].stringValue)
                    var items = item["Sender"]
                    self.id.append(items["ID"].intValue)
                    print(self.messagequeue)
                    print(self.id)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
        }
        
        task.resume()
        
    }

    
    @IBAction func SendBtnAction(sender: AnyObject) {
        if(self.textfield.text!.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Enter Text"),animated: true,completion: nil)
        }
        else {
        text = self.textfield.text!
        print(text)
        messagequeue.append(text)
            id.append(Int(userid)!)
        textfield.text = ""
            getuserid()
            let usermodel = UserModel1.init(ID: userid)!
            let messageviewmodel = MessageViewModel.init(Sender: usermodel, MessageContent: text, messageThreadID: threadid)
            let serializedjson  = JSONSerializer.toJson(messageviewmodel)
            print(serializedjson)
            CreateMessageinServer(Appconstant.WEB_API+Appconstant.SEND_MESSAGE, value: serializedjson)
        }
    }
    func getuserid(){
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
                userid = "\(results.intForColumn("USERID"))"
                print(userid)
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
        
        
    }
    
    func CreateMessageinServer(url : String,value : String){
        let username = "rajagcs08@gmail.com"
        let password = "1234"
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


}
