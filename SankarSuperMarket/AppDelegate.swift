//
//  AppDelegate.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
import Contacts
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate  {
//class AppDelegate: UIResponder, UIApplicationDelegate   {
    var window: UIWindow?
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String = "684097176981"
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"
    

    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Override point for customization after application launch.

        if gcmSenderID.characters.count > 0 {
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            if configureError != nil {
                print("Error configuring the Google context: \(configureError)")
            }
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            print(settings)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
            // GCMService.sharedInstance().startWithConfig(GCMConfig.defaultConfig())
            let gcmConfig = GCMConfig.defaultConfig()
            gcmConfig.receiverDelegate = self
            GCMService.sharedInstance().startWithConfig(gcmConfig)
        }

        return true
    }
  

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


   
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            print("Notification received: \(userInfo)")
             print(userInfo)
            
            // This works only if the app started the GCM service
            // Check if value present before using it
            
//            let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("yapcustomer.db")
//            let databasePath = databaseURL.absoluteString
//            let yapcustomerDB = FMDatabase(path: databasePath as String)
//            if yapcustomerDB.open() {
//                
//                if let info = userInfo as? Dictionary<String,String> {
//                    let data = info["transaction"]!.dataUsingEncoding(NSUTF8StringEncoding)
//                    let transaction  = JSON(data: data!)
//                    let bal = info["balance"]!.dataUsingEncoding(NSUTF8StringEncoding)
//                    
//                    let balanceValue  = JSON(data: bal!)
//
//                    notification.timeZone = NSTimeZone.defaultTimeZone()
//                    let dateTime = NSDate().dateByAddingTimeInterval(20)
//                    notification.fireDate = dateTime
//                    var notificationMsg : String?
//                    let Name = transaction["otherPartyName"].stringValue
//                    var Names = Name.characters.split{$0 == " "}.map(String.init)
//                    if transaction["type"].stringValue == "CREDIT"
//                    {
//                        if Names[0] == Names[1]
//                        {
//                            notificationMsg = "You have received Rs. " + transaction["amount"].stringValue + " from "
//                            notificationMsg = notificationMsg! + Names[0] + " : Balance - Rs. " + balanceValue["balance"].stringValue;
//                            
//                        }
//                        else{
//                            notificationMsg = "You have received Rs. " + transaction["amount"].stringValue + " from "
//                            notificationMsg = notificationMsg! + transaction["otherPartyName"].stringValue + " : Balance - Rs. " + balanceValue["balance"].stringValue;
//                        }
//                    }
//                    else if transaction["type"].stringValue == "DEBIT"
//                    {
//                        if Names[0] == Names[1]
//                        {
//                            notificationMsg = "You have paid Rs. " + transaction["amount"].stringValue + " to "
//                            notificationMsg = notificationMsg! + Names[0] + " : Balance - Rs. " + balanceValue["balance"].stringValue;
//                            
//                        }
//                        else{
//                            notificationMsg = "You have paid Rs. " + transaction["amount"].stringValue + " to "
//                            notificationMsg = notificationMsg! + transaction["otherPartyName"].stringValue + " : Balance - Rs. " + balanceValue["balance"].stringValue;
//                        }
//                    }
//                    notification.alertBody = notificationMsg
            let notification = UILocalNotification()
                        notification.userInfo = userInfo
                       print(userInfo)
            
            
            print(notification)
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                    
//                    let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("yapcustomer.db")
//                    let databasePath = databaseURL.absoluteString
//                    let yapcustomerDB = FMDatabase(path: databasePath as String)
//                    if yapcustomerDB.open() {
//                        let dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
//                        let currentDateTime =  dateFormatter.stringFromDate(NSDate(timeIntervalSince1970:Double(NSDate().timeIntervalSince1970)))
//                        
//                        let notificationInsert = "INSERT INTO NOTIFICATIONLOG (MESSAGE, TIMESTAMP, CONTENT, ISREAD, NOTIFICATIONTYPE, FUNDREQUESTNO, DATETIME) VALUES ('\(notificationMsg!)','\(NSDate().timeIntervalSince1970)','\(notificationMsg!)','\(false)','\("Transaction")','\(0)','\(currentDateTime)')"
//                        let result = yapcustomerDB.executeUpdate(notificationInsert,
//                            withArgumentsInArray: nil)
//                        
//                        if !result {
//                            //   status.text = "Failed to add contact"
//                            print("Error: \(yapcustomerDB.lastErrorMessage())")
//                        }
//                        else {
//                            print(result)
//                        }
//                        
//                        if transaction["status"].stringValue.lowercaseString.containsString("success")
//                        {
//                            
//                            let insertSQL = "INSERT INTO YAPTRANSACTION (AMOUNT, TRANSACTIONTYPE, MERCHANTNAME, MERCHANTID, BALANCE, TRANSACTIONDATE, TRANSACTIONSTATUS, TRANSACTIONMODE, TRANSACTIONREF, BENEFICIARYNAME, OTHERPARTYNAME, YOURWALLET, BENEFICIARYWALLET) VALUES"
//                            let value1 = "('\(transaction["amount"].floatValue)', '\(transaction["type"].stringValue)', '\(transaction["beneficiaryName"].stringValue)', '\(transaction["beneficiaryId"].stringValue)','\(balanceValue["balance"].floatValue)','\(transaction["time"].stringValue)','\("Completed")','\(transaction["txnOrigin"].stringValue)','\(transaction["txRef"].stringValue)'"
//                            let value2 = ",'\(transaction["beneficiaryName"].stringValue)','\(transaction["otherPartyName"].stringValue)','\(transaction["yourWallet"].stringValue)','\(transaction["beneficiaryWallet"].stringValue)')"
//                            let values = insertSQL + value1 + value2
//                            print(values)
//                            let result = yapcustomerDB.executeUpdate(values,
//                                withArgumentsInArray: nil)
//                            
//                            if !result {
//                                //   status.text = "Failed to add contact"
//                                print("Error: \(yapcustomerDB.lastErrorMessage())")
//                            }
//                            else {
//                                print(result)
//                            }
//                        }
//                    }
//                    else
//                    {
//                        let insertSQL = "INSERT INTO YAPTRANSACTION (AMOUNT, TRANSACTIONTYPE, MERCHANTNAME, MERCHANTID, BALANCE, TRANSACTIONDATE, TRANSACTIONSTATUS, TRANSACTIONMODE, TRANSACTIONREF, BENEFICIARYNAME, OTHERPARTYNAME, YOURWALLET, BENEFICIARYWALLET) VALUES"
//                        let value1 = "('\(transaction["amount"].floatValue)', '\(transaction["type"].stringValue)', '\(transaction["beneficiaryName"].stringValue)', '\(transaction["beneficiaryId"].stringValue)','\(balanceValue["balance"].floatValue)','\(transaction["time"].stringValue)','\("Pending")','\(transaction["txnOrigin"].stringValue)','\(transaction["txRef"].stringValue)'"
//                        let value2 = ",'\(transaction["beneficiaryName"].stringValue)','\(transaction["otherPartyName"].stringValue)','\(transaction["yourWallet"].stringValue)','\(transaction["beneficiaryWallet"].stringValue)')"
//                        let values = insertSQL + value1 + value2
//                        
//                        let result = yapcustomerDB.executeUpdate(values,
//                            withArgumentsInArray: nil)
//                        
//                        if !result {
//                            //   status.text = "Failed to add contact"
//                            print("Error: \(yapcustomerDB.lastErrorMessage())")
//                        }
//                        else {
//                            print("Error: \(yapcustomerDB.lastErrorMessage())")
//                        }
//                        
//                    }
//                }
//                else {
//                    print("no value for key\n")
//                }
//                
//            }
//            yapcustomerDB.close()
//            
            
            GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            // Handle the received message
            // [START_EXCLUDE]
            NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                userInfo: userInfo)
            // [END_EXCLUDE]
    }
    
    //    func application( application: UIApplication,
    //                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
    //                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
    //        print("Notification received: \(userInfo)")
    //        // This works only if the app started the GCM service
    //        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
    //        // Handle the received message
    //        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    //        // [START_EXCLUDE]
    //        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
    //                                                                  userInfo: userInfo)
    //        handler(UIBackgroundFetchResult.NoData);
    //        // [END_EXCLUDE]
    //    }
    
   
   
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        GCMService.sharedInstance().connectWithHandler({(error:NSError?) -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // ...
            }
        })
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func registerForPushNotifications(application: UIApplication) {
        // if #available(iOS 8.0, *) {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        GCMService.sharedInstance().startWithConfig(GCMConfig.defaultConfig())
        //        } else {
        //            // Fallback
        //            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        //            application.registerForRemoteNotificationTypes(types)
        //        }
        
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        // [END receive_apns_token]
        // [START get_gcm_reg_token]
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
            kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        // [END get_gcm_reg_token]
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NSNotificationCenter.defaultCenter().postNotificationName(
            registrationKey, object: nil, userInfo: userInfo)
    }
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        
        print("RT is:"+registrationToken!)
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error:NSError?) -> Void in
                    if let error = error {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            print("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        NSLog("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    


}

