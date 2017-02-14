//
//  PersonaldetailViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/22/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
import Photos

class PersonaldetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var nametxt: UITextField!
    
    @IBOutlet var mobilenotxt: UITextField!
    
    @IBOutlet var emailtxt: UITextField!
    
    @IBOutlet var savebtn: UIButton!
    
    @IBOutlet var cancelbtn: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profileimg: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var userid = ""
    var oldusername = ""
    var emailid = ""
    var imagepath = ""
    var password1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdetails()
        self.profileimg.layer.cornerRadius = self.profileimg.frame.size.height/2
        self.profileimg.clipsToBounds = true
        
        
        imagePicker.delegate = self
        nametxt.layer.borderColor = UIColor.blackColor().CGColor
        mobilenotxt.layer.borderColor = UIColor.blackColor().CGColor
        emailtxt.layer.borderColor = UIColor.blackColor().CGColor
        
        nametxt.userInteractionEnabled = false
        mobilenotxt.userInteractionEnabled = false
        emailtxt.userInteractionEnabled = false
        savebtn.hidden = true
        cancelbtn.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
        savebtn.layer.cornerRadius = 15
        cancelbtn.layer.cornerRadius = 15
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, nametxt.frame.height - 1, nametxt.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, mobilenotxt.frame.height - 1, mobilenotxt.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.grayColor().CGColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, emailtxt.frame.height - 1, emailtxt.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.grayColor().CGColor
        nametxt.borderStyle = UITextBorderStyle.None
        nametxt.layer.addSublayer(bottomLine)
        mobilenotxt.borderStyle = UITextBorderStyle.None
        mobilenotxt.layer.addSublayer(bottomLine1)
        emailtxt.borderStyle = UITextBorderStyle.None
        emailtxt.layer.addSublayer(bottomLine2)
   
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(imagepath.isEmpty){
        }
        else {
//            let profileimag =  UIImage(data: NSData(contentsOfURL: NSURL(string:self.imagepath)!)!)
            var profileimag: UIImage? = UIImage(contentsOfFile: self.imagepath)
            if profileimag == nil {
                profileimag = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
            }
            profileimg.image = profileimag
            self.profileimg.layer.cornerRadius = 10
            self.profileimg.layer.cornerRadius = self.profileimg.frame.size.height/2
            self.profileimg.clipsToBounds = true
        }

    }
    
    
    
    @IBAction func EditBtnAction(sender: AnyObject) {
        nametxt.userInteractionEnabled = true
        savebtn.hidden = false
        cancelbtn.hidden = false
        
    }
    func getdetails() {
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
                nametxt.text = results.stringForColumn("NAME")
                mobilenotxt.text = results.stringForColumn("PHONENUMBER")
                emailtxt.text = results.stringForColumn("EMAILID")
                emailid = results.stringForColumn("EMAILID")
                userid = "\(results.intForColumn("USERID"))"
                oldusername = results.stringForColumn("NAME")
                password1 = results.stringForColumn("PASSWORD")
            }
         supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
//        let profileviewmodel = ProfileViewModel.init(EmailID: emailid, Password: password)!
//        let serializedjson  = JSONSerializer.toJson(profileviewmodel)
//        print(serializedjson)
//        getProfileImage(Appconstant.WEB_API+Appconstant.AUTHENTICATE_URL, value: serializedjson)
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

    
    @IBAction func savebtnAction(sender: AnyObject) {
        nametxt.text = self.nametxt.text!
        nametxt.userInteractionEnabled = false
        savebtn.hidden = true
        cancelbtn.hidden = true
       checkconnection()
        let UserViewmodel = UserViewModel.init(ID: userid, Name: self.nametxt.text!)!
        let serializedjson  = JSONSerializer.toJson(UserViewmodel)
        sendrequesttoserver(Appconstant.WEB_API+Appconstant.UPDATE_PROFILE, value: serializedjson)
        
    }
    func sendrequesttoserver(url : String,value : String)
    {
       
        let username = self.emailid
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
                
                DBHelper().opensupermarketDB()
                let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                let databasePath = databaseURL.absoluteString
                let supermarketDB = FMDatabase(path: databasePath as String)
                if supermarketDB.open() {
                    
                    let insertSQL = "UPDATE LOGIN SET NAME = '"+self.nametxt.text!+"' WHERE USERID=" + "\(item["ID"].intValue)"
                    
                    let result = supermarketDB.executeUpdate(insertSQL,
                        withArgumentsInArray: nil)
                    if !result {
                        //   status.text = "Failed to add contact"
                        print("Error: \(supermarketDB.lastErrorMessage())")
                    }
                }
                 dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(Alert().alert("Name changed", message: ""),animated: true,completion: nil)
                }
        }
 
        
        task.resume()
        
    }

    
    @IBAction func TakePhotoBtnAction(sender: AnyObject) {
        
        
        var alertController:UIAlertController?
        alertController?.view.tintColor = UIColor.blackColor()
        alertController = UIAlertController(title: "Add Photo!",
            message: "",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
            
            self!.takePhotoFromCamera()
            
            })
        let action1 = UIAlertAction(title: "Choose from Gallery", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
            
            self!.takePhotofromGallery()
            
            })
        
       
        
        
        let action2 = UIAlertAction(title: "Remove Photo", style: UIAlertActionStyle.Default, handler: {[weak self](paramAction:UIAlertAction!) in
           self!.checkconnection()
            self!.profileimg.image = UIImage(named: "threadimg.png")
            let base64String1: String = ""
            
            let imagemodel = ImageViewModel.init(ID: self!.userid, Image: base64String1)!
            let serializedjson  = JSONSerializer.toJson(imagemodel)
            self!.sendrequesttoserverforProfileImage(Appconstant.WEB_API+Appconstant.UPDATE_PROFILE, value: serializedjson)
            
            })

        
        
        let action4 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        
        alertController?.addAction(action)
        alertController?.addAction(action1)
        alertController?.addAction(action2)
        alertController?.addAction(action4)
        self.presentViewController(alertController!, animated: true, completion: nil)
        

        }
    func takePhotoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)

        }
    }
    func takePhotofromGallery(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileimg.contentMode = .ScaleAspectFit
            profileimg.image = pickedImage
            self.profileimg.layer.cornerRadius = 10
            let image : UIImage = pickedImage
            let imageData = UIImagePNGRepresentation(image)
           // let base64String: String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            let base64String:String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            checkconnection()
            activityIndicator.startAnimating()
            let imagemodel = ImageViewModel.init(ID: userid, Image: base64String)!
            let serializedjson  = JSONSerializer.toJson(imagemodel)
            print(serializedjson)
            sendrequesttoserverforProfileImage(Appconstant.WEB_API+Appconstant.UPDATE_PROFILE, value: serializedjson)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    func sendrequesttoserverforProfileImage(url : String,value : String)
    {
     
        let username = self.emailid
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
                else {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var item = json["result"]
    
                self.imagepath = item["ImagePath"].stringValue;
                print(self.imagepath)
                    if(self.imagepath.isEmpty) {
                        
                    }
                    else {

//            let profileimag =  UIImage(data: NSData(contentsOfURL: NSURL(string:self.imagepath)!)!)
                        var profileimag: UIImage? = UIImage(contentsOfFile: self.imagepath)
                        if profileimag == nil {
                            profileimag = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                        }

                    print(self.imagepath)
                        
                self.profileimg.image = profileimag
//                    self.profileimg.layer.cornerRadius = 5
                    
                        
                    }
         
                }
                self.activityIndicator.stopAnimating()
        }
        
        
        task.resume()
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_profile") {
            let nextview = segue.destinationViewController as! AccountViewController
            
            nextview.imagepath = imagepath
        }
    }
    
    @IBAction func cancelbtnAction(sender: AnyObject) {
        nametxt.userInteractionEnabled = false
        savebtn.hidden = true
        cancelbtn.hidden = true
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
