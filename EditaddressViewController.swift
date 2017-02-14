//
//  EditaddressViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class EditaddressViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nametxt: UITextField!
    
    @IBOutlet weak var addr1: UITextField!
    
    @IBOutlet weak var addr2: UITextField!
    
    @IBOutlet weak var citytxt: UITextField!
    
    @IBOutlet weak var statetxt: UITextField!
    
    @IBOutlet weak var countrytxt: UITextField!
    
    @IBOutlet weak var pincodetxt: UITextField!

    @IBOutlet weak var mobilenotxt: UITextField!
    
    @IBOutlet weak var save: UIButton!
    
    var userid = ""
    var addressid = ""
    
    var edit = 0
    var name = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var country = ""
    var pincode = ""
    var mobileno = ""
    var characterCountLimit = 0
    var username1 = ""
    var password1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        save.layer.cornerRadius = 15
        statetxt.delegate = self
        countrytxt.delegate = self
        pincodetxt.delegate = self
        pincodetxt.keyboardType = UIKeyboardType.NumberPad
        mobilenotxt.delegate = self
        mobilenotxt.keyboardType = UIKeyboardType.NumberPad
        
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)
        if(edit == 1){
            nametxt.text = name
            addr1.text = address1
            addr2.text = address2
            citytxt.text = city
            statetxt.text = state
            countrytxt.text = country
            pincodetxt.text = pincode
            mobilenotxt.text = mobileno
        }
        
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

    
    
    func sendrequesttoserver(url : String,value : String)
    {
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
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var item = json["result"]
   
                self.addressid = item["ID"].stringValue

                if(self.edit == 1){
                    dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(Alert().alert("Changes saved successfully", message: ""),animated: true,completion: nil)
                    self.nametxt.text = ""
                    self.addr1.text = ""
                    self.addr2.text = ""
                    self.citytxt.text = ""
                    self.statetxt.text = ""
                    self.countrytxt.text = ""
                    self.pincodetxt.text = ""
                    self.mobilenotxt.text = ""
                    }
                }
        }
        
        task.resume()
        
    }

    
    

    func alert(title: String,message: String)-> UIAlertController
    {
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textFieldToChange == pincodetxt){
            
         characterCountLimit = 6
        }
        if(textFieldToChange == mobilenotxt){
             characterCountLimit = 10
        }
        else{
            characterCountLimit = 20
        }
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
    
    
        return newLength <= characterCountLimit
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.placeholder == "STATE") {
            animateViewMoving(true, moveValue: 170)
        }
        if(textField == countrytxt) {
            animateViewMoving(true, moveValue: 170)
        }
        if(textField == pincodetxt) {
            
            animateViewMoving(true, moveValue: 170)
        }
        if(textField == mobilenotxt) {
            animateViewMoving(true, moveValue: 170)
        }

    }
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == statetxt) {
            animateViewMoving(false, moveValue: 170)
        }
        if(textField == countrytxt) {
            animateViewMoving(false, moveValue: 170)
        }
        if(textField == pincodetxt) {
            animateViewMoving(false, moveValue: 170)
        }
        if(textField == mobilenotxt) {
            animateViewMoving(false, moveValue: 170)
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

    
    @IBAction func SavebtnAction(sender: AnyObject) {
        let name: String = self.nametxt.text!
        let addr1: String = self.addr1.text!
        let addr2: String = self.addr2.text!
        let city: String = self.citytxt.text!
        let state: String = self.statetxt.text!
        let country: String = self.countrytxt.text!
        let pin: String = self.pincodetxt.text!
        let mobileno: String = self.mobilenotxt.text!
        if(name.isEmpty || addr1.isEmpty || addr2.isEmpty || city.isEmpty || state.isEmpty || country.isEmpty || pin.isEmpty || mobileno.isEmpty) {
            self.presentViewController(Alert().alert("Warning", message: "Don't leave empty space"),animated: true,completion: nil)
        }
        else {
            
            if(edit == 0) {
               checkconnection()
            let userid1: Int = Int(userid)!
            let pincode: Int = Int(self.pincodetxt.text!)!
            let citymodel = CityViewModel.init(Name: self.citytxt.text!)!
            let statemodel = StateViewModel.init(Name: self.statetxt.text!)!
            let countrymodel = CountryViewModel.init(Name: self.countrytxt.text!)!
            let usermodel = UserProfile.init(ID: userid1)!
            print(userid1)
            let contactmodel = ContactViewModel.init(Contactno: self.mobilenotxt.text!, userprofile: usermodel)!
      
            
            let Addressviewmodel = AddressViewModel.init(UserID: Int(userid)!, Name: self.nametxt.text!, AddressLine1: self.addr1.text!, AddressLine2: self.addr2.text!, City: citymodel, State: statemodel, Country: countrymodel, ContactNumber: contactmodel, Pincode: pincode)!
            let serializedjson  = JSONSerializer.toJson(Addressviewmodel)
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.ADDRESS_CREATE, value: serializedjson)

        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            
            let insertSQL = "INSERT INTO ADDRESS (ADDRESSID, NAME, ADDRESS1, ADDRESS2, CITY, STATE, COUNTRY, PINCODE, MOBILENO) VALUES ('\(self.addressid)','\(self.nametxt.text!)','\(self.addr1.text!)','\(self.addr2.text!)','\(self.citytxt.text!)','\(self.statetxt.text!)','\(self.countrytxt.text!)','\(self.pincodetxt.text!)','\(self.mobilenotxt.text!)' )"
            
            let result = supermarketDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            if !result {
                //   status.text = "Failed to add contact"
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            else
            {
                self.presentViewController(Alert().alert("Address added successfully", message: ""),animated: true,completion: nil)
                self.nametxt.text = ""
                self.addr1.text = ""
                self.addr2.text = ""
                self.citytxt.text = ""
                self.statetxt.text = ""
                self.countrytxt.text = ""
                self.pincodetxt.text = ""
                self.mobilenotxt.text = ""
                
            }
            
        }

        }
            else {
                let userid1: Int = Int(userid)!
                let pincode: Int = Int(self.pincodetxt.text!)!
                let citymodel = CityViewModel2.init(Name: self.citytxt.text!)!
                let statemodel = StateViewModel2.init(Name: self.statetxt.text!)!
                let countrymodel = CountryViewModel2.init(Name: self.countrytxt.text!)!
                let usermodel = UserProfile2.init(ID: userid1)!
                let contactmodel = ContactViewModel2.init(Contactno: self.mobilenotxt.text!, userprofile: usermodel)!
                
                
                let Addressviewmodel = AddressupdateViewModel.init(ID: addressid, UserID: userid, Name: self.nametxt.text!, AddressLine1: self.addr1.text!, AddressLine2: self.addr2.text!, City: citymodel, State: statemodel, Country: countrymodel, ContactNumber: contactmodel, Pincode: pincode)!
                let serializedjson  = JSONSerializer.toJson(Addressviewmodel)
                sendrequesttoserver(Appconstant.WEB_API+Appconstant.ADDRESS_UPDATE, value: serializedjson)

                
            }
    }

        
        
    }
        

    
}




