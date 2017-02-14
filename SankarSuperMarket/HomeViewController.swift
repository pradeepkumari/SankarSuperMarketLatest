//
//  HomeViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.


import UIKit


class HomeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
     // var Appconstant.Appconstant.notificationItems = [Notification]()
     var categoryItems = [Category]()
   //  var Appconstant.no_of_notification_items = -1
    var timer = NSTimer()
    var count = 0
    var movecount = 1
    var value: UIImage?
    var check = 0
    var username1 = ""
    var password1 = ""
    var activitystop = 0
    var cartcountnumber = 0
    var userid = ""
    var categoryimgurl = [UIImage]()
        var imageCache = [String:UIImage]()
    
    var baseViewForTopImageView: UIView = UIView()
    var noticeimg: UIImageView = UIImageView()
    var categorylabel: UILabel = UILabel()
    var pageController: UIPageControl = UIPageControl()
    
    @IBOutlet weak var SearchBar: UIBarButtonItem!
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
//    @IBOutlet weak var categorylbl: UILabel!
   
//    @IBOutlet weak var noticeimg: UIImageView!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
//    @IBOutlet weak var pageController: UIPageControl!
         var scrollView: UIScrollView!
    
    var sidemenu: UIBarButtonItem!
    @IBOutlet weak var cartbtn: UIButton!

        @IBOutlet weak var tableView: UITableView!
    var search: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: Selector("revealToggle:"))
//        self.view.addGestureRecognizer(tapGesture)

      
        baseViewForTopImageView.frame = CGRectMake(0, 0, self.view.frame.size.width , 210)
        
        tableView.tableHeaderView = baseViewForTopImageView
        noticeimg.frame = CGRectMake(0, 0, self.view.frame.size.width, 175)
        [baseViewForTopImageView .addSubview(noticeimg)]
        categorylabel.frame = CGRectMake(0, noticeimg.frame.size.height, self.view.frame.size.width, 35)
        categorylabel.text = "Categories"
        categorylabel.backgroundColor = Appconstant.bgcolor
        categorylabel.textColor = UIColor(red: 95.0/255.0, green: 176.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        categorylabel.font = UIFont(name: "Arial", size: 18)
        
        categorylabel.textAlignment = NSTextAlignment.Center
        [baseViewForTopImageView .addSubview(categorylabel)]
pageController.frame = CGRectMake(self.view.center.x-(self.view.frame.size.width/11), noticeimg.frame.size.height-15, self.view.frame.size.width, 15)
        configurePageControl()
        [baseViewForTopImageView .addSubview(pageController)]
        
        
        //activityIndicator.startAnimating()
         checkconnection()
        sidemenu = UIBarButtonItem(image: UIImage(named: "Menu_36.png"), style: .Plain, target: self, action: Selector("action"))
        navigationItem.leftBarButtonItem = sidemenu
        sidemenu.target = self.revealViewController()
        sidemenu.action = Selector("revealToggle:")
        
//        Open.target = self.revealViewController()
//        Open.action = Selector("revealToggle:")
//        self.cartbtn = UIButton(type: .Custom)
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        self.cartbtn.setTitle("0", forState: .Normal)
        cartbtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        
        cartbtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
        cartbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)

        cartbtn.tintColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        cartbtn.backgroundColor = Appconstant.btngreencolor
        cartbtn.titleLabel?.textColor = Appconstant.btngreencolor
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        
        search = UIBarButtonItem(image: UIImage(named: "search.png"), style: .Plain, target: self, action: Selector("searchaction"))
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cartbtn)
        DBHelper().opensupermarketDB()
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        let databasePath = databaseURL.absoluteString
        let supermarketDB = FMDatabase(path: databasePath as String)
        if supermarketDB.open() {
            
            let selectSQL = "SELECT * FROM CATEGORY"
            
            let results:FMResultSet! = supermarketDB.executeQuery(selectSQL,
                                                                  withArgumentsInArray: nil)
            if((results) != nil)
            {
                self.categoryItems = [Category]()
            while (results.next())
            {
               // var imgurl = results.stringForColumn("EMAILID")
                
                var img =  UIImage(data: NSData(contentsOfURL: NSURL(string:results.stringForColumn("imagePath"))!)!)
                 var cimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:results.stringForColumn("CategoryIcon"))!)!)
                let category = Category(ID: results.stringForColumn("CATEGORYID"), Name: results.stringForColumn("Name"), CategoryPhoto : img!, imagePath: results.stringForColumn("imagePath"))!
                    self.categoryimgurl.append(cimg!)
                    self.categoryItems += [category];
                
            }
            }
            
        }
        supermarketDB.close()
    self.tableView.reloadData()
        getuserdetails()

        if(Appconstant.homepage==0)
        {
            self.sendrequesttoserveragain()
            self.sendrequesttoserver()
            Appconstant.homepage=1
        }
        else{
        if(Appconstant.no_of_notification_items>1)
        {
        self.pageController.numberOfPages = Appconstant.no_of_notification_items + 1
        self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target:self, selector: Selector("ChangeImageAction"), userInfo: nil, repeats: true)
            ChangeImageAction(true)
            ChangeImageAction(false)

        }
        else{
            self.sendrequesttoserveragain()

        }
            
                   }
        
      
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

    func configurePageControl()
    {
        self.pageController.currentPage = 0
        self.pageController.tintColor = UIColor.redColor()
        self.pageController.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageController.currentPageIndicatorTintColor = UIColor(red: 130.0/255.0, green: 132.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true
//        search = UIBarButtonItem(image: UIImage(named: "search.png"), style: .Plain, target: self, action: Selector("searchaction"))
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        navigationItem.rightBarButtonItem = search
        
        cartcountnumber = 0
        Getcartcount()
        
        self.view.userInteractionEnabled = false

        self.view.userInteractionEnabled = true
    }
    
    func searchaction(){
        
//        let nextvc = SearchViewController()
//        self.navigationController!.pushViewController(nextvc, animated: true)
        
        self.performSegueWithIdentifier("goto_search", sender: self)
        
    }
    

    @IBAction func FloatBtnAction(sender: AnyObject) {
        self.performSegueWithIdentifier("fromhome_tocart", sender: self)
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
           navigationItem.hidesBackButton = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                ChangeImageAction(true)
            case UISwipeGestureRecognizerDirection.Left:
                ChangeImageAction(false)
            default:
                break
            }
        }
    }
    
    
    func ChangeImageAction(let moveLeft:Bool) {
        if moveLeft
        {
            count -= 1
        }
        else
        {
            count += 1
        }
        
        if count < 0
        {
            count = Appconstant.no_of_notification_items
            self.pageController.currentPage = Appconstant.no_of_notification_items
        }
       
        if count > Appconstant.no_of_notification_items
        {
//            count = Appconstant.no_of_notification_items
            count = 0
            self.pageController.currentPage = 0
        }
        
        
        self.pageController.currentPage = count
        
        let notification = Appconstant.notificationItems[count]
        noticeimg.image = notification.NotificationPhoto
        
    }

    
    func GotoCartView(){
        self.performSegueWithIdentifier("fromhome_tocart", sender: self)
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
                print(results.stringForColumn("EMAILID"))
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }
   
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "homeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell!
       // if(activitystop == 2) {
       // activityIndicator.stopAnimating()
       // }
        
        let category = categoryItems[indexPath.row ]
        let categoryimg = cell.viewWithTag(2) as! UIImageView
        let categorylbl = cell.viewWithTag(3) as! UILabel
        categorylbl.text = category.Name
        categorylbl.textColor = UIColor(red: 95.0/255.0, green: 176.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        categorylbl.font = UIFont(name: "Helvetica LT std roman", size: 14)
        categoryimg.image = category.CategoryPhoto
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Appconstant.bgcolor.CGColor

        if(check == 0){
            let clr = UIColor(red: 176, green: 240, blue: 148, alpha: 1)
            cell.layer.backgroundColor = clr.CGColor
            check = 1
        }
        else {
            let clr = UIColor(red: 46, green: 71, blue: 30, alpha: 1)
            cell.layer.backgroundColor = clr.CGColor
            check = 0
        }
        baseViewForTopImageView.backgroundColor = Appconstant.bgcolor
        return cell
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }

    
    func sendrequesttoserver()
    {
         activityIndicator.startAnimating()
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GETCATEGORY)!)
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
                    self.presentViewController(Alert().alert("No network", message: "Check internet connection"),animated: true,completion: nil)
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                
                let json = JSON(data: data!)
                
                DBHelper().opensupermarketDB()
                let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                let databasePath = databaseURL.absoluteString
                let supermarketDB = FMDatabase(path: databasePath as String)
                    let deleteSQL =  "DELETE FROM CATEGORY"
                    let dresult = supermarketDB.executeUpdate(deleteSQL,
                                                              withArgumentsInArray: nil)
                    if !dresult {
                        //   status.text = "Failed to add contact"
                        print("Error: \(supermarketDB.lastErrorMessage())")
                    }
                self.categoryItems = [Category]()
                
                for item in json["result"].arrayValue {
                     var cimgurl = "";
                    if(item["ImageUrl"].stringValue == "")
                    {
                        cimgurl = "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png"
                        
                    }
                    else{
                     cimgurl = Appconstant.IMAGEURL1+"Images/Category/"+item["ImageUrl"].stringValue
                    }
                    var categoryimgPath = ""
                    if(item["CategoryIcon"].stringValue=="")
                    {
                        categoryimgPath = "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png"
                    }
                    else
                    {
                        categoryimgPath = Appconstant.IMAGEURL1+"Icon/Category/"+item["CategoryIcon"].stringValue
                    }
                    
                     var cimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:cimgurl)!)!)
//                        var cimg = UIImage(contentsOfFile: cimgurl)
                        if cimg == nil {
                            cimg = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                        }
                    var img =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
//                        var img = UIImage(contentsOfFile: categoryimgPath)
                        if img == nil {
                            img = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                        }
                  
                    let category = Category(ID: item["ID"].stringValue, Name: item["Name"].stringValue, CategoryPhoto : img!, imagePath: categoryimgPath)!
                    
                   self.categoryimgurl.append(cimg!)
                    self.categoryItems += [category];
                    DBHelper().opensupermarketDB()
                    let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
                    let databasePath = databaseURL.absoluteString
                    let supermarketDB = FMDatabase(path: databasePath as String)
                    if supermarketDB.open() {
                        
                        let insertSQL = "INSERT INTO CATEGORY (CATEGORYID, NAME, imagePath,CategoryIcon) VALUES ('\(item["ID"].stringValue)','\(item["Name"].stringValue)','\(categoryimgPath)','\(cimgurl)')"
                        
                        let result = supermarketDB.executeUpdate(insertSQL,
                                                                 withArgumentsInArray: nil)
                        if !result {
                            //   status.text = "Failed to add contact"
                            print("Error: \(supermarketDB.lastErrorMessage())")
                        }
                        else
                        {
                        }
                    }
                    
                }
                self.activitystop += 1
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                   //  self.activityIndicator.stopAnimating()
                }
        }
        task.resume()
        
    }
    func sendrequesttoserveragain() {
      //  activityIndicator.startAnimating()
        let username = self.username1
        let password = self.password1
        print(username1)
        print(password1)
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "https://ttltracker.azurewebsites.net/task/getallwalllist")!)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GETNOTICE)!)
        request.HTTPMethod = "GET"
      
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        //    let postString = "Username="+self.txtUsername.text!+"&Password="+self.txtPassword.text!
        //    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)!")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
               
                let jsons = JSON(data: data!)
                for item in jsons["result"].arrayValue {
                   
                    let NotificationimgPath = Appconstant.IMAGEURL+"Images/Notice/"+item["ImagePath"].stringValue;
                    
//                    var nimg: UIImage? = UIImage(data: NSData(contentsOfURL: NSURL(string:NotificationimgPath)!)!)
//                    print(UIImage(contentsOfFile: NotificationimgPath))
                        var nimg: UIImage? = UIImage(contentsOfFile: NotificationimgPath)
                    if let data = NSData(contentsOfURL: NSURL(string:NotificationimgPath)!) {
                        let nimg: UIImage? = UIImage(data: NSData(contentsOfURL: NSURL(string:NotificationimgPath)!)!)
                        let notification = Notification(Title: item["Title"].stringValue, Description: item["Description"].stringValue, StartDate: item["StartDate"].stringValue,ExpiryDate: item["ExpiryDate"].stringValue,  NotificationPhoto : nimg!)!
                        Appconstant.no_of_notification_items += 1;
                        Appconstant.notificationItems += [notification];
                    }
                        else {
                          let nimg = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://bplus1.blob.core.windows.net/cdn/bplus_sankarsupermarket/Images/Business/loading_sqr.png")!)!)
                        let notification = Notification(Title: item["Title"].stringValue, Description: item["Description"].stringValue, StartDate: item["StartDate"].stringValue,ExpiryDate: item["ExpiryDate"].stringValue,  NotificationPhoto : nimg!)!
                        Appconstant.no_of_notification_items += 1;
                        Appconstant.notificationItems += [notification];
                        }
                    
                        
                }
                self.activitystop += 1
                dispatch_async(dispatch_get_main_queue()) {
//                     self.noticeimg.image = self.Appconstant.notificationItems[0].NotificationPhoto
                    self.pageController.numberOfPages = Appconstant.no_of_notification_items + 1
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target:self, selector: Selector("ChangeImageAction"), userInfo: nil, repeats: true)
                    
                    self.activityIndicator.stopAnimating()
                }
        }
        task.resume()
   
    }

    func Getcartcount() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
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
                var item = json["result"]
                for item2 in item["CartLineItemList"].arrayValue{
                    
                    self.cartcountnumber = self.cartcountnumber + 1
                    
                    
                }

                
                dispatch_async(dispatch_get_main_queue()) {
                    self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
                }
        }
        
        task.resume()
        
    }
    
    
   
    
    

    func ChangeImageAction() {
        if (Appconstant.no_of_notification_items >= count) {
            if (count < 0) {
                count = 0
                self.pageController.currentPage = 0
            }
        let notification = Appconstant.notificationItems[count]

            noticeimg.image = notification.NotificationPhoto

            
        count = count + 1
            self.pageController.currentPage += 1
        }
            if (Appconstant.no_of_notification_items + 1 == count) {
                count = 0
                self.pageController.currentPage = 0
            }
     }
    
    func ChangeImageActionForRightSwipe() {
        
        if (Appconstant.no_of_notification_items >= count) {
            if (count < 0) {
                count = 0
                self.pageController.currentPage = 0
            }
            let notification = Appconstant.notificationItems[count]
            
            noticeimg.image = notification.NotificationPhoto
            
            
            count = count - 1
            if count != -1
            {
            self.pageController.currentPage -= 1
            }
            else
            {
               self.pageController.currentPage = Appconstant.no_of_notification_items
                count = Appconstant.no_of_notification_items
            }
        }

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_productlist") {
                let nextview = segue.destinationViewController as! ProductViewController
           let indexPath = self.tableView.indexPathForSelectedRow
                nextview.categoryimage = self.categoryimgurl[(indexPath?.row)!]
            nextview.categoryID = self.categoryItems[(indexPath?.row)!].ID
            nextview.navigationtitle = self.categoryItems[(indexPath?.row)!].Name
            nextview.cartcountnumber = self.cartcountnumber
            }
        if(segue.identifier == "goto_search"){
            let nextvc = segue.destinationViewController as! SearchViewController
            nextvc.cartcountnumber = self.cartcountnumber
        }
    }

    
 }
