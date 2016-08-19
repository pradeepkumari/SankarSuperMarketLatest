//
//  Forgotpassword.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/5/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ForgotpasswordViewController: UIViewController {
    
    var emailid = ""
    var phonenumber = ""
    
    @IBOutlet weak var mailidtxt: UITextField!
    
    @IBOutlet weak var OTPtxt: UITextField!
    
    @IBOutlet weak var newpwdtxt: UITextField!
    
    @IBOutlet weak var conformpwdtxt: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailidtxt.text = self.emailid
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        submit.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
    }
    func textFieldDidBeginEditing(textField: UITextField) {
   
        if(textField.placeholder == "New Password") {
            animateViewMoving(true, moveValue: 150)
        }
        if(textField.placeholder == "Conform Password") {
            animateViewMoving(true, moveValue: 150)
        }
        
        
    }
    func textFieldDidEndEditing(textField: UITextField) {

        if(textField.placeholder == "New Password") {
            animateViewMoving(false, moveValue: 150)
        }
        if(textField.placeholder == "Conform Password") {
            animateViewMoving(false, moveValue: 150)
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
    

    @IBAction func SubmitOTPAction(sender: AnyObject) {
        let otp: String = self.OTPtxt.text!
        let newpwd: String = self.newpwdtxt.text!
        let confirmpwd: String = self.conformpwdtxt.text!
        if (otp.isEmpty || newpwd.isEmpty || confirmpwd.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Don't leave empty space"),animated: true,completion: nil)
        }
        else if(newpwd != confirmpwd) {
            self.presentViewController(Alert().alert("Warning", message: "Enter correct password"),animated: true,completion: nil)
        }
        else {
            Reachability().checkconnection()
            let submitOTPViewmodel = SubmitOTP.init(EmailID: self.emailid, OTP: self.OTPtxt.text!, PhoneNumber: self.emailid, Password: self.newpwdtxt.text!)!
            let serializedjson  = JSONSerializer.toJson(submitOTPViewmodel)
            print(serializedjson)
            sendrequesttoserverForsubmitOTP(Appconstant.WEB_API+Appconstant.FORGOT_PASSCODE, value: serializedjson)
            
        }

        
    }
    
    func sendrequesttoserverForsubmitOTP(url : String,value : String)
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
                if (item["Status"].stringValue == "Success"){
                    dispatch_async(dispatch_get_main_queue()) {

                    self.performSegueWithIdentifier("back_signin", sender: self)
                    }
                }
                else{
                    self.presentViewController(Alert().alert("Warning", message: "Invalid OTP"),animated: true,completion: nil)
                }

        }
        
        task.resume()
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

        }
        
        task.resume()
    }

    
    
    @IBAction func ResendOTPBtn(sender: AnyObject) {
        Reachability().checkconnection()
        let resendViewmodel = ResendOTP.init(EmailID: self.emailid, PhoneNumber: self.emailid)!
        let serializedjson  = JSONSerializer.toJson(resendViewmodel)
        print(serializedjson)
        sendrequesttoserverForOTP(Appconstant.WEB_API+Appconstant.RESEND_OTP, value: serializedjson)

    }


}
