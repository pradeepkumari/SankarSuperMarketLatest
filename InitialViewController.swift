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
        self.view.backgroundColor = UIColor.whiteColor()
        a = 1.0
        
//        addBackgroundImage()
//        addLogo()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01, target: self, selector: Selector("addLogo"), userInfo: nil, repeats: true
        )
      
        navigationController?.navigationBar.hidden = true
        
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func addLogo() {
     
        
        let img = UIImageView(image: UIImage(named: "logo.png"))

        img.frame = CGRectMake( self.view.frame.size.width/2 - (50 + a/2) , 145 , 100 + a, 100 + a )
        a += 0.5
        
        if(a == 40.0){
            timer.invalidate()
            checkconnection()
            checkfunc()
//            sendrequesttoserver(Appconstant.WEB_API+Appconstant.SIGNUP_URL)
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
