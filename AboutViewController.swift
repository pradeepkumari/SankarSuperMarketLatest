//
//  AboutViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    var content: String!
    var username1 = ""
    var password1 = ""
    var home: UIBarButtonItem!
    
    @IBOutlet weak var contentlabel: UILabel!
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.tabBarController?.tabBar.hidden = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        home = UIBarButtonItem(image: UIImage(named: "ic_home_36pt.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = home
        sideBarButton.target = revealViewController()
        sideBarButton.action = Selector("revealToggle:")
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
                    self.username1 = results.stringForColumn("EMAILID")
                    self.password1 = results.stringForColumn("PASSWORD")
                    
                }
                supermarketDB.close()
            } else {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
        
        Reachability().checkconnection()
        sendrequesttoserver()
        
    }
    func action(){
        self.performSegueWithIdentifier("go_home4", sender: self)
    }
    
    func sendrequesttoserver()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.ABOUT_CONTENT)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                

                
                let json = JSON(data: data!)
                var item = json["result"]
                 self.content = item["Content"].stringValue
                let encodedData = self.content.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions : [String: AnyObject] = [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ]
                let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                let decodedString = attributedString!.string
                
                 dispatch_async(dispatch_get_main_queue()) {
                self.contentlabel.text = decodedString
                    self.activityIndicator.stopAnimating()
                }
//                self.set(decodedString)
        }
        task.resume()
        
    }

    
//    func set(str: String){
//        contentlabel.text = str
//    }
    
}


