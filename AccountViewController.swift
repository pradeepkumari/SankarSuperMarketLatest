//
//  AccountViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/10/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    @IBOutlet weak var notification: UIButton!
   
    @IBOutlet weak var order: UIButton!
 
    @IBOutlet weak var address: UIButton!

    @IBOutlet weak var feedback: UIButton!

    @IBOutlet weak var profile: UIButton!
    

    @IBOutlet weak var changepwd: UIButton!
    
    @IBOutlet weak var logout: UIButton!
    
    @IBOutlet var usernamelabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var profileimg: UIImageView!
    var home: UIBarButtonItem!
    var id: Int32 = 0
    var emailid = ""
    var password1 = ""
    var imagepath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.profileimg.image = UIImage(named: "threadimg.png")
        self.profileimg.layer.cornerRadius = self.profileimg.frame.size.height/2
        self.profileimg.clipsToBounds = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home

     notificationSwitch.addTarget(self, action: Selector("SwitchAction"), forControlEvents: UIControlEvents.ValueChanged)
        order.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        address.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        profile.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        changepwd.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        logout.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        notification.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        feedback.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadfunc();
    }
    func action() {
        self.performSegueWithIdentifier("gohome_fromaccount", sender: self)
    }
    func SwitchAction(){
        if notificationSwitch.on {
            print("ON")
        } else {
           print("OFF")
        }
    }
    func loadfunc() {
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
            let databasePath = databaseURL.absoluteString
            let supermarketDB = FMDatabase(path: databasePath as String)
            if supermarketDB.open() {
                let querySQL = "SELECT * FROM LOGIN"
                
                let results:FMResultSet? = supermarketDB.executeQuery(querySQL,
                    withArgumentsInArray: nil)
                if (results?.next() != nil) {
                    
                    usernamelabel.text = results?.stringForColumn("NAME")
                    emailid = (results?.stringForColumn("EMAILID"))!
                    password1 = (results?.stringForColumn("PASSWORD"))!
                }
                let profileviewmodel = ProfileViewModel.init(EmailID: emailid, Password: password1)!
                let serializedjson  = JSONSerializer.toJson(profileviewmodel)
                print(serializedjson)
                getProfileImage(Appconstant.WEB_API+Appconstant.AUTHENTICATE_URL, value: serializedjson)

            }
        supermarketDB.close()
        }
    
    @IBAction func LogoutBtnAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure want to logout", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alertAction in
            

        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
    
        if supermarketDB.open() {
            
            let selectSQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
                withArgumentsInArray: nil)
            
            while(results.next()) {
            self.id = results.intForColumn("ID")
            
            let deleteSQL =  "DELETE FROM LOGIN WHERE ID =" + "\(self.id)"
            let result = supermarketDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            if !result {
                //   status.text = "Failed to add contact"
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
          }
        }
            self.performSegueWithIdentifier("go_initial", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { alertAction in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        

        
    }
    
    func getProfileImage(url : String,value : String){
        let username = emailid
        let password = password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
 
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
     
        
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
                
                self.imagepath = item["ImagePath"].stringValue
                if(self.imagepath.isEmpty) {
//                    self.profileimg.image = UIImage(named: "threadimg.png")
                }
                else {
                    print(self.imagepath)
                    
                let profileimage =  UIImage(data: NSData(contentsOfURL: NSURL(string:self.imagepath)!)!)
//                let image = UIImageView(frame: CGRectMake(0, 0, 100, 100))
                     dispatch_async(dispatch_get_main_queue()) {
                self.profileimg.image = profileimage
                    }
                }
                
        }
        
        
        task.resume()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_profile") {
            let nextview = segue.destinationViewController as! PersonaldetailViewController
            
            nextview.imagepath = imagepath
        }
    }

  
    @IBAction func FeedBackBtnAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Rate SankarSuperMarket", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "http://bit.ly/29QvH8q")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { alertAction in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        feedback.showsTouchWhenHighlighted = true



    
    }
    
}
