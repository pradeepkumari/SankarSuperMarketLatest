//
//  ConnectionViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
import SystemConfiguration

public class Reachability: UIViewController {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

        
    
    func checkconnection() {
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
}

class ConnectionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goto(){

         self.presentViewController(Alert().alert("No network", message: "Check internet connection"),animated: true,completion: nil)
//        let connectionview = ConnectionViewController()
//        self.presentViewController(connectionview, animated: true, completion: nil)
    }

    
    @IBAction func RetryAction(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            let initialview = InitialViewController()
            self.presentViewController(initialview, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func CloseAction(sender: AnyObject) {
        exit(0)
    }
   }
