//
//  InitialViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/23/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
 
    @IBOutlet weak var logoimg: UIImageView!
    var timer = NSTimer()
    var a: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        logoimg.hidden = true
        a = 1.0
        Reachability().checkconnection()
//        addBackgroundImage()
//        addLogo()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01, target: self, selector: Selector("addLogo"), userInfo: nil, repeats: true
        )
      
        
        
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func addLogo() {
     
        
        let img = UIImageView(image: UIImage(named: "ic_launcher.png"))

        img.frame = CGRectMake( self.view.frame.size.width/2 - (50 + a/2) , 145 , 100 + a, 100 + a )
        a += 0.5
        
        if(a == 40.0){
            timer.invalidate()
            sendrequesttoserver(Appconstant.WEB_API+Appconstant.SIGNUP_URL)
        }
        self.view.addSubview(img)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() ->Bool {
    return true
    }
    
    func sendrequesttoserver(url : String)
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
                    self.checkfunc()
                    
                }
                
                
        }
        
        task.resume()
        
    }
    
    
    func checkfunc() {
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            let querySQL = "SELECT * FROM LOGIN"
            
            let results:FMResultSet! = supermarketDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            if (results.next()) {
                self.performSegueWithIdentifier("homepage", sender: self)
                
            }
            else {
                self.performSegueWithIdentifier("login", sender: self)
            }
        }
        
    }


}
