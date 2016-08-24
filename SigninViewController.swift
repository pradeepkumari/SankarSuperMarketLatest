//
//  SigninViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var txtmailid: UITextField!
    
    @IBOutlet weak var txtpassword: UITextField!
    
    @IBOutlet weak var signin: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    var check = 0;
    var mailid = ""
    var passcode = ""
    var userid = ""

    @IBOutlet weak var subview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signin.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
        txtmailid.delegate = self
        txtpassword.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    func alert(title: String,message: String)-> UIAlertController
    {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        return alert
        
    }
    @IBAction func Signinbtn(sender: AnyObject) {
        let username: String = self.txtmailid.text!
        let password: String = self.txtpassword.text!
        if (username.isEmpty || password.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Don't leave empty space"),animated: true,completion: nil)
        }
        else {
            Reachability().checkconnection()
            let loginViewmodel = Login.init(EmailID: self.txtmailid.text!, Password: self.txtpassword.text!)!
            let serializedjson  = JSONSerializer.toJson(loginViewmodel)
            print(serializedjson)
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.AUTHENTICATE_URL, value: serializedjson)

       }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == txtmailid) {
            animateViewMoving(true, moveValue: 200)
        }
        if(textField == txtpassword) {
            animateViewMoving(true, moveValue: 200)
        }

    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == txtmailid) {
            animateViewMoving(false, moveValue: 200)
        }
        if(textField == txtpassword) {
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
    
    func sendrequesttoserver(url : String,value : String)
    {
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
                }
               
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                 var item = json["result"]
                
                if(item["ID"].intValue <= 0) {
                    dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(Alert().alert("Alert", message: "Login failed..."),animated: true,completion: nil)
                        self.txtmailid.text = ""
                        self.txtpassword.text = ""
                    }
                   

                }
                else {
                
                    self.userid = "\(item["ID"].stringValue)"
                    self.mailid = item["EmailID"].stringValue
                    self.passcode = item["Password"].stringValue
                    DBHelper().opensupermarketDB()
                    let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                    let databasePath = databaseURL.absoluteString
                    let supermarketDB = FMDatabase(path: databasePath as String)
                    if supermarketDB.open() {
//                        let selectSQL = "SELECT * FROM LOGIN"
//                        
//                        
//                        let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
//                            withArgumentsInArray: nil)
//
//                        if(!results.next()){
                        
                        let insertSQL = "INSERT INTO LOGIN (USERID,NAME,EMAILID,PASSWORD,PHONENUMBER) VALUES ('\(item["ID"].stringValue)','\(item["Name"].stringValue)','\(self.txtmailid.text!)','\(self.txtpassword.text!)','\(item["PhoneNumber"].stringValue)')"
                        
                        let result = supermarketDB.executeUpdate(insertSQL,
                            withArgumentsInArray: nil)
                        if !result {
                            //   status.text = "Failed to add contact"
                            print("Error: \(supermarketDB.lastErrorMessage())")
                              }
                        else {
                            dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("Signin", sender: self)
                             }
                            }
                        
//                         }
//                        else{
//                            dispatch_async(dispatch_get_main_queue()) {
//                            self.performSegueWithIdentifier("Signin", sender: self)
//                            }
                    }
                }
                
                
                }
        
           task.resume()
     }
     func dismissKeyboard() {
         view.endEditing(true)
     }
 
    
    @IBAction func ForgotPasswordBtnAction(sender: AnyObject) {
        let username1: String = self.txtmailid.text!
        if (username1.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Enter Email-ID"),animated: true,completion: nil)
        }
        else {
            let resendViewmodel = ResendOTP.init(EmailID: self.txtmailid.text!, PhoneNumber: self.txtmailid.text!)!
            let serializedjson  = JSONSerializer.toJson(resendViewmodel)
            print(serializedjson)
            sendrequesttoserverForOTP(Appconstant.WEB_API+Appconstant.RESEND_OTP, value: serializedjson)
            
        }

    }
    
    func sendrequesttoserverForOTP(url : String,value : String)
    {
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
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                let item = json["result"].stringValue
                if item == "true" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("goto_OTP", sender: self)
                    }
                }
              
        }
        
        task.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_OTP") {
            let nextviewcontroller = segue.destinationViewController as! ForgotpasswordViewController
            nextviewcontroller.emailid = self.txtmailid.text!
            
        }
    }

}

