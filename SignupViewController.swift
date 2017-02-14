//
//  SignupViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UITextFieldDelegate {
    
    var authenticated : Bool = true

    
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var txtname: UITextField!
    
    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var txtmobileno: UITextField!
 
    @IBOutlet weak var txtpwd: UITextField!
    
    @IBOutlet weak var appimg: UIImageView!
    
    @IBOutlet weak var appnamelbl: UILabel!

    @IBOutlet weak var txtconfirmpwd: UITextField!
    var id = ""
    var characterCountLimit = 0
    var cartlineid = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.whiteColor()
        signup.layer.cornerRadius = 20
        signup.backgroundColor = UIColor(red: 104.0/255.0, green: 191.0/255.0, blue: 74.0/255.0, alpha:1.0)
        self.signup.layer.shadowOpacity = 2
        self.signup.layer.shadowRadius = 5
        self.signup.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.signup.layer.shadowColor = UIColor(red: 175.0/255.0, green: 213.0/255.0, blue: 159.0/255.0, alpha:1.0).CGColor
        
        navigationController?.navigationBar.hidden = true
        
        
        txtmobileno.delegate = self
        txtmobileno.keyboardType = UIKeyboardType.NumberPad
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func alert(title: String,message: String)-> UIAlertController
    {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
    @IBAction func Signupbtnaction(sender: AnyObject) {
        let username: String = self.txtname.text!
        let emailid: String = self.txtemail.text!
        let mobilenumber: String = self.txtmobileno.text!
        let password: String = self.txtpwd.text!
        let confirmpassword: String = self.txtconfirmpwd.text!
        if(username.isEmpty || emailid.isEmpty || mobilenumber.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Don't leave empty space"),animated: true,completion: nil)
        }
        else if(password != confirmpassword) {
            self.presentViewController(Alert().alert("Warning", message: "Enter correct password"),animated: true,completion: nil)
        }
            
        else {
//            DatabaseCallforCartItems()
//            deleteCartdatabase()
            checkconnection()
        let signupViewmodel = Signupviewmodel.init(Name: self.txtname.text!, EmailID: self.txtemail.text!, PhoneNumber: self.txtmobileno.text!, Password: self.txtpwd.text!)!
        let serializedjson  = JSONSerializer.toJson(signupViewmodel)
            print(serializedjson)
        sendrequesttoserver(Appconstant.WEB_API+Appconstant.SIGNUP_URL, value: serializedjson)
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
                if(item["ID"].intValue < 0){
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(Alert().alert("Alert", message: "Signup failed..."),animated: true,completion: nil)
                        self.txtname.text = ""
                        self.txtemail.text = ""
                        self.txtmobileno.text = ""
                        self.txtpwd.text = ""
                        self.txtconfirmpwd.text = ""
                    }
                    
                    
                }

                else{
                DBHelper().opensupermarketDB()
                let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                let databasePath = databaseURL.absoluteString
                let supermarketDB = FMDatabase(path: databasePath as String)

                if supermarketDB.open() {
                    
                    let insertSQL = "INSERT INTO SIGNUP (NAME,EMAILID,MOBILENUMBER,PASSWORD,CONFIRMPASSWORD) VALUES ('\(self.txtname.text!)','\(self.txtemail.text!)','\(self.txtmobileno.text!)','\(self.txtpwd.text!)','\(self.txtconfirmpwd.text!)' )"
                    
                    let result = supermarketDB.executeUpdate(insertSQL,
                        withArgumentsInArray: nil)
                    if !result {
                        //   status.text = "Failed to add contact"
                        print("Error: \(supermarketDB.lastErrorMessage())")
                    }
//                    self.addressdatabasecall()
//                    self.performSegueWithIdentifier("goto_homepage", sender: self)
                }
                supermarketDB.close()
        
                if supermarketDB.open() {
                    
                    let insertSQL = "INSERT INTO LOGIN (USERID,NAME,EMAILID,PASSWORD,PHONENUMBER) VALUES ('\(item["ID"].stringValue)','\(item["Name"].stringValue)','\(self.txtemail.text!)','\(self.txtpwd.text!)','\(self.txtmobileno.text!)')"
                    
                    let result = supermarketDB.executeUpdate(insertSQL,
                        withArgumentsInArray: nil)
                    if !result {
                        //   status.text = "Failed to add contact"
                        print("Error: \(supermarketDB.lastErrorMessage())")
                    }
//                    self.performSegueWithIdentifier("goto_homepage", sender: self)
                }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("goto_homepage", sender: self)
        }
    }
 
        task.resume()
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.placeholder == "Mobile Number") {
            animateViewMoving(true, moveValue: 200)
        }
        if(textField.placeholder == "Password") {
            animateViewMoving(true, moveValue: 200)
        }
        if(textField.placeholder == "Confirm Password") {
            animateViewMoving(true, moveValue: 200)
        }
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
 
            if(textFieldToChange == txtmobileno){
                characterCountLimit = 10
            }
            let startingLength = textFieldToChange.text?.characters.count ?? 0
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            
            return newLength <= characterCountLimit
        }
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.placeholder == "Mobile Number") {
            animateViewMoving(false, moveValue: 200)
        }
        if(textField.placeholder == "Password") {
            animateViewMoving(false, moveValue: 200)
        }
        if(textField.placeholder == "Confirm Password") {
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
    
    
//    func addressdatabasecall() {
//        
//        DBHelper().opensupermarketDB()
//        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
//        let databasePath = databaseURL.absoluteString
//        let supermarketDB = FMDatabase(path: databasePath as String)
//
//        if supermarketDB.open() {
//            let querySQL = "SELECT * FROM ADDRESS"
//            
//            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
//                withArgumentsInArray: nil)
//            
//            while(results.next()) {
//                self.id = "\(results.intForColumn("ID"))"
//                let deleteSQL = "DELETE FROM ADDRESS WHERE ID =" + "\(self.id)"
//                
//                supermarketDB.executeQuery(deleteSQL,
//                    withArgumentsInArray: nil)
//
//
//            }
//            supermarketDB.close()
//            
//        }
//            
//        else {
//            print("Error: \(supermarketDB.lastErrorMessage())")
//        }
//        
//    }
//
//    func DatabaseCallforCartItems() {
//        DBHelper().opensupermarketDB()
//        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
//        let databasePath = databaseURL.absoluteString
//        let supermarketDB = FMDatabase(path: databasePath as String)
//        if supermarketDB.open() {
//            let querySQL = "SELECT * FROM CARTITEMS"
//            
//            let results:FMResultSet? = supermarketDB.executeQuery(querySQL,
//                withArgumentsInArray: nil)
//            while ((results?.next()) == true) {
//                
//                cartlineid.append((results?.stringForColumn("CARTLINEID"))!)
//            }
//        }
//        else {
//            print("Error: \(supermarketDB.lastErrorMessage())")
//        }
//    }
//    
//    func deleteCartdatabase() {
//        DBHelper().opensupermarketDB()
//        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
//        let databasePath = databaseURL.absoluteString
//        let supermarketDB = FMDatabase(path: databasePath as String)
//        for(var i = 0; i<cartlineid.count; i++){
//            if supermarketDB.open() {
//                let deleteSQL =  "DELETE FROM CARTITEMS WHERE CARTLINEID =" + "\(cartlineid[i])"
//                let result = supermarketDB.executeUpdate(deleteSQL,
//                    withArgumentsInArray: nil)
//                if !result {
//                    //   status.text = "Failed to add contact"
//                    print("Error: \(supermarketDB.lastErrorMessage())")
//                }
//            }
//        }
//    }

    
}
  






