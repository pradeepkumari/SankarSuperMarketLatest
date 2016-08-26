//
//  RootViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/6/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items = [String]()
    var id: Int32 = 1
    
    @IBOutlet weak var tableView: UITableView!
    var home = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = ["Gallery","Notification","Wish List","My Cart","offer","location","shareapp","FAQ","About Us","My Account","Logout"]
        
        self.navigationController?.navigationBarHidden = true
        
        let backgroundImage = UIImageView(frame: CGRectMake(0, 0, 320, 800))

        backgroundImage.image = UIImage(named: "greenbackground.jpeg")

        
        self.tableView.insertSubview(backgroundImage, atIndex: 0)
        

        
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier(items[indexPath.row], forIndexPath: indexPath) as UITableViewCell!
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
    return cell
    }
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 6){
            
            let textToShare = "Check out this website about it!"
            
            if let myWebsite = NSURL(string: "http://bit.ly/29QvH8q") {
                let objectsToShare = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
//                activityVC.popoverPresentationController?.sourceView = sender
                self.presentViewController(activityVC, animated: true, completion: nil)
                
                if let popView = activityVC.popoverPresentationController {
                    popView.sourceView = tableView
                    popView.sourceRect = tableView.cellForRowAtIndexPath(indexPath)!.frame
                }
            }

        }
        
        else if(indexPath.row == 10) {
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
                self.performSegueWithIdentifier("goto_initial", sender: self)
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { alertAction in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
           
        }
    }
    
    
}
