//
//  MapViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/23/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import MapKit
import UIKit

//class Capital: NSObject, MKAnnotation {
//    var title: String?
//    var coordinate: CLLocationCoordinate2D
//    var info: String
//    
//    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
//        self.title = title
//        self.coordinate = coordinate
//        self.info = info
//    }
//}


var latitude = [Double]()
var longitude = [Double]()
var addr1 = [String]()
var addr2 = [String]()
var addressline1 = ""
var addressline2 = ""

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    var username1 = ""
    var password1 = ""
    
    let regionRadius: CLLocationDistance = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        sideBarButton.target = revealViewController()
        sideBarButton.action = Selector("revealToggle:")
        getuserdetails()
        Reachability().checkconnection()
        sendrequesttoserverToGetLocation()
        
     
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
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
    }

  
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = addressline1
        annotation.subtitle = addressline2
        self.mapView.addAnnotation(annotation)
        

        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
            regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_homeview", sender: self)
    }

    func sendrequesttoserverToGetLocation()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
   
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_BRANCH)!)
        request.HTTPMethod = "GET"
        // set Content-Type in HTTP header
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //     print("GET RESPONSE")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("ERROR")
                    print("response = \(response)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
              
                let json = JSON(data: data!)
                for item1 in json["result"].arrayValue {
                    let address = item1["Address"]
                    latitude.append(address["Latitude"].doubleValue)
                    longitude.append(address["Longitude"].doubleValue)
                    addr1.append(address["AddressLine1"].stringValue)
                    addr2.append(address["AddressLine2"].stringValue)
                }
                print(latitude)
                for(var i = 0; i<latitude.count; i++) {
                let initialLocation = CLLocationCoordinate2D(latitude: latitude[i], longitude: longitude[i])
                    addressline1 = addr1[i]
                    addressline2 = addr2[i]
                self.centerMapOnLocation(initialLocation)
                }
         
        }
        task.resume()
    }


}
