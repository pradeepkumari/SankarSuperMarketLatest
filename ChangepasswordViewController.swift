//
//  ChangepasswordViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/24/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ChangepasswordViewController: UIViewController, UITextFieldDelegate {
    

    
    @IBOutlet weak var oldpwdtext: UITextField!
  
    @IBOutlet weak var newpwdtext: UITextField!
    
    @IBOutlet weak var confirmtext: UITextField!

    @IBOutlet weak var change: UIButton!
    
    
    var userid = ""
    var userID = 0
    var username1 = ""
    var password1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, oldpwdtext.frame.height - 1 , oldpwdtext.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        oldpwdtext.borderStyle = UITextBorderStyle.None
        oldpwdtext.layer.addSublayer(bottomLine)
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, newpwdtext.frame.height - 1, newpwdtext.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.grayColor().CGColor
        newpwdtext.borderStyle = UITextBorderStyle.None
        newpwdtext.layer.addSublayer(bottomLine1)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, confirmtext.frame.height - 1, confirmtext.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.grayColor().CGColor
        confirmtext.borderStyle = UITextBorderStyle.None
        confirmtext.layer.addSublayer(bottomLine2)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        change.layer.cornerRadius = 16
        newpwdtext.delegate = self
        confirmtext.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
    }
    func dismissKeyboard() {
        view.endEditing(true)
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

    @IBAction func ChangebtnAction(sender: AnyObject) {
   
        
        let newpassword = self.newpwdtext.text!
        let confirmpassword = self.confirmtext.text!
       
        if (newpassword.isEmpty || confirmpassword.isEmpty || self.oldpwdtext.text!.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Don't leave empty space"),animated: true,completion: nil)
        }
        else if(newpassword != confirmpassword) {
            self.presentViewController(Alert().alert("Warning", message: "Enter correct password"),animated: true,completion: nil)
        }
        else if((self.oldpwdtext.text!) != self.password1){
            self.presentViewController(Alert().alert("Warning", message: "Old Password is wrong"),animated: true,completion: nil)
        }
        else {
            checkconnection()
            let changepassword = ChangePassword.init(ID: userid, Password: self.newpwdtext.text!)!
            let serializedjson  = JSONSerializer.toJson(changepassword)
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.USER_CHANGE_PASSWORD, value: serializedjson)
            
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

    func sendrequesttoserver(url : String,value : String)
    {
        checkconnection()
        print(url)
        print(value)
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
                    return
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                self.userID = Int(self.userid)!
                DBHelper().opensupermarketDB()
                let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                let databasePath = databaseURL.absoluteString
                let supermarketDB = FMDatabase(path: databasePath as String)
                if supermarketDB.open() {
                    
                    let insertSQL = "UPDATE LOGIN SET PASSWORD = '"+self.newpwdtext.text!+"' WHERE USERID="+"\(self.userID)"
                    "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
                    let result = supermarketDB.executeUpdate(insertSQL,
                        withArgumentsInArray: nil)
//                    if !result {
//                        //   status.text = "Failed to add contact"
//                        print("Error: \(supermarketDB.lastErrorMessage())")
//                    }
//                    else{
                          dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(Alert().alert("Password changed successfully", message: ""),animated: true,completion: nil)
                           self.password1 = self.newpwdtext.text!
                            self.oldpwdtext.text = ""
                            self.newpwdtext.text = ""
                            self.confirmtext.text = ""
                       // }

                    }
                }
                
        }
        
        
        task.resume()
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == newpwdtext) {
            animateViewMoving(true, moveValue: 200)
        }
        if(textField == confirmtext) {
            animateViewMoving(true, moveValue: 200)
        }
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == newpwdtext) {
            animateViewMoving(false, moveValue: 200)
        }
        if(textField == confirmtext) {
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

    
}
