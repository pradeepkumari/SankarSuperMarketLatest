//
//  SearchViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 8/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var categoryproductItems1 = [CategoryProduct1]()
    
    var productvariantItems1 = [ProductVariantList1]()
    var listItems = [List]()
    var username1 = ""
    var password1 = ""
    var userid = ""
    var wishimage = [String]()
    var alert = 0
    var alertindex = 0
    var typealertno = 0
    var check = 0
    var cartid = 0
    
    var id = [Int]()
    var proid = [Int]()
    var name = [String]()
    var stock = [String]()
    var type = [String]()
    var price = [String]()
    var Discountpercent = [String]()
    var Discountprice = [String]()
    var unitid = [String]()
    var unit = [String]()
    var quantity = [String]()
    var cartcount = [Int]()
    var searchtext = ""
    
    var wishpath = 0
    var wishlistid = [String]()
    var wishlistname = [String]()
    

    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var close: UIBarButtonItem!
    var home: UIBarButtonItem!
    var searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserdetails()
        
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        cartbtn.setImage(UIImage(named: "mycart_36.png"), forState: UIControlState.Normal)
        cartbtn.tintColor = UIColor.whiteColor()
        cartbtn.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
        cartbtn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        //        cartbtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        Reachability().checkconnection()
        sendrequesttoserverforCartid()
        tableView.dataSource = self
        tableView.delegate = self
        SearchBar.delegate = self
        SearchBar.showsCancelButton = false
        getWishList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.userid = results.stringForColumn("USERID")
                self.username1 = results.stringForColumn("EMAILID")
                self.password1 = results.stringForColumn("PASSWORD")
                
            }
            supermarketDB.close()
        } else {
            print("Error: \(supermarketDB.lastErrorMessage())")
        }

    }

    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        cartbtn.frame = CGRectMake(522, 800, 45, 45)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("text edit")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //        filterContentForSearchText(searchController.searchBar.text!)
        if(searchBar.text! == ""){
        }
            
//        else if(check == 0)
        else {
            
            check = 1
            let pagelistviewmodel = PagelistViewModel.init(OrderByColumn: "", OrderByType: "", Productname: searchBar.text!, pageSize: 50, categoryID: 0, pageNumber: 0)!
            let serializedjson  = JSONSerializer.toJson(pagelistviewmodel)
            print(serializedjson)
            searchtext = searchBar.text!
            activeIndicator.startAnimating()
            sendrequesttoserverFilter(Appconstant.WEB_API+Appconstant.GET_PAGELIST, value: serializedjson);
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as UITableViewCell!
        
        let productimg = cell.viewWithTag(1) as! UIImageView
        let productlbl = cell.viewWithTag(2) as! UILabel
        let wishimg = cell.viewWithTag(6) as! UIButton
        let pricelbl = cell.viewWithTag(4) as! UILabel
        let cartcountlbl = cell.viewWithTag(8) as! UILabel
        let btn = cell.viewWithTag(12) as! UIButton
            print(indexPath.row)
            print(listItems[indexPath.row].Name)
            let lists = listItems[indexPath.row]
            if(lists.wish == "true"){
                wishimg.setBackgroundImage(UIImage(named: "fav_filled.png"), forState: UIControlState.Normal)
            }
            else {
                wishimg.setBackgroundImage(UIImage(named: "fav_outline.png"), forState: UIControlState.Normal)
            }
            
            productlbl.text = lists.Name
            productimg.image = lists.ProductPhoto
            pricelbl.text = "\u{20B9}" + lists.DiscountPrice
            cartcountlbl.text = "\(lists.cartCount)"
            btn.setTitle(lists.Type, forState: UIControlState.Normal)
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            btn.layer.cornerRadius = 3
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.grayColor().CGColor




        if(check == 1){
            check = 0
            
        }
        self.activeIndicator.stopAnimating()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listItems.count)
        return listItems.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goto_product2", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clearColor().CGColor
        selectionColor.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectionColor
    }

    
 
    
    func sendrequesttoserverFilter(url : String, value : String)
    {
        
        print(value)
        print(url)
        self.categoryproductItems1.removeAll()
        self.productvariantItems1.removeAll()
        self.listItems.removeAll()
        self.wishimage.removeAll()
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
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
                
                
//                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//               
//                print("responseString = \(responseString)")
                let json = JSON(data: data!)
                

                let item2 = json["result"]
                if(item2["searchKey"].stringValue == self.searchtext) {
                for item in item2["productList"].arrayValue {
                    
                    self.id.removeAll()
                    self.proid.removeAll()
                    self.name.removeAll()
                    self.stock.removeAll()
                    self.type.removeAll()
                    self.price.removeAll()
                    self.Discountpercent.removeAll()
                    self.Discountprice.removeAll()
                    self.unit.removeAll()
                    self.unitid.removeAll()
                    self.quantity.removeAll()
                    self.cartcount.removeAll()
                    
                   
                    let categoryimgPath = Appconstant.IMAGEURL+"Images/Products/"+item["ImageUrl"].stringValue;
                    let productimg =  UIImage(data: NSData(contentsOfURL: NSURL(string:categoryimgPath)!)!)
                    
                    self.wishimage.append(item["IsWishListed"].stringValue)
                    self.productvariantItems1 = [ProductVariantList1]()
                    
                    for product in  item["ProductVariantList"].arrayValue {
                        
                        self.id.append(product["ID"].intValue)
                        self.proid.append(product["ProductID"].intValue)
                        self.name.append(product["ProductName"].stringValue)
                        self.stock.append(product["Stock"].stringValue)
                        self.type.append(product["Description"].stringValue)
                        self.price.append(product["Price"].stringValue)
                        self.Discountpercent.append(product["DiscountPercentage"].stringValue)
                        self.Discountprice.append(product["DiscountPrice"].stringValue)
                        self.unit.append(product["Unit"].stringValue)
                        self.unitid.append(product["UnitID"].stringValue)
                        self.quantity.append(product["Quantity"].stringValue)
                        self.cartcount.append(product["cartCount"].intValue)
                        
                        let productvariantlist1 = ProductVariantList1(ID: product["ID"].intValue, ProductID: product["ProductID"].intValue,  ProductName: product["ProductName"].stringValue,
                            Price: product["Price"].stringValue, Stock: product["Stock"].stringValue, DiscountPercentage: product["DiscountPercentage"].stringValue, DiscountPrice: product["DiscountPrice"].stringValue, Unit: product["Unit"].stringValue, Type: product["Description"].stringValue,
                            Quantity: product["Quantity"].stringValue, UnitID: product["UnitID"].stringValue, cartCount: product["cartCount"].intValue)!
                        self.productvariantItems1 += [productvariantlist1];
                        
                    }
                    
                    let categoryproduct1 = CategoryProduct1(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue,  ProductPhoto : productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductvariantList: self.productvariantItems1)!
                    
                    let list = List(ID: item["ID"].stringValue, Name: item["Name"].stringValue, Description: item["Description"].stringValue, ProductPhoto: productimg!, Productimgurl: item["ImageUrl"].stringValue, ProductVariantID: self.id[0], ProductID: self.proid[0], ProductName: self.name[0], Price: self.price[0], Stock: self.stock[0], DiscountPercentage: self.Discountpercent[0], DiscountPrice: self.Discountprice[0], Unit: self.unit[0], Type: self.type[0], Quantity: self.quantity[0], UnitID: self.unitid[0], cartCount: self.cartcount[0], wish: item["IsWishListed"].stringValue)!
                    
                    self.categoryproductItems1 += [categoryproduct1];
                    self.listItems += [list];
                    
                    
                }
                if(self.categoryproductItems1.count == 0){
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(Alert().alert("", message: "No product items found"),animated: true,completion: nil)
                    }
                }
                   
                    
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                
                }
            }
                else{
                    print(self.listItems.count)
                }
        }
        
        task.resume()
        
    }

    func getWishList() {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_ALL_WISH_LIST+self.userid)!)
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
                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //     print("responseString = \(responseString)")
                self.wishlistid.removeAll()
                self.wishlistname.removeAll()
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
                    self.wishlistid.append(item["ID"].stringValue)
                    self.wishlistname.append(item["Name"].stringValue)
                }
                print(self.wishlistname)
                if(self.alert == 1){
                    self.alert = 0
                    self.alertFunction()
                }
        }
        
        task.resume()
        
    }
    
    
    func sendrequesttoserverforCartid()
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Appconstant.WEB_API+Appconstant.GET_CART_OPEN+self.userid)!)
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
                //    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //     print("responseString = \(responseString)")
                let json = JSON(data: data!)
                var item = json["result"]
                self.cartid = item["ID"].intValue
               
                
                
        }
        
        
        
        task.resume()
        
    }

    
    func CreateWishListItem(url : String,value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
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
                
        }
        
        task.resume()
    }

    
    @IBAction func TypeBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        alertindex = indexPath.row
        let alertView1: UIAlertView = UIAlertView()
        alertView1.delegate = self
        alertView1.title = "Product Variant"
        typealertno = 1
            for(var i = 0; i<self.categoryproductItems1[indexPath.row].ProductvariantList.count; i++){
                print(self.categoryproductItems1[indexPath.row].ProductvariantList.count)
                alertView1.addButtonWithTitle("\(self.categoryproductItems1[indexPath.row].ProductvariantList[i].Type)" + " - " + "Rs." + "\(self.categoryproductItems1[indexPath.row].ProductvariantList[i].Price)")
            }
        
            alertView1.show()
        
    }
    
    func alertFunction(){
        let alertView: UIAlertView = UIAlertView()
        alertView.delegate = self
        alertView.title = "Wish List"
        for(var i = 0; i<wishlistid.count ; i++){
            alertView.addButtonWithTitle("\(wishlistname[i])")
            
        }
        alertView.addButtonWithTitle("Create New Wishlist")
        alertView.addButtonWithTitle("Cancel")
        alertView.show()
    }
    
    
    @IBAction func WishBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        wishpath = indexPath.row
        alertFunction()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(typealertno == 1){
            typealertno = 0
                
                listItems[alertindex].ProductVariantID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ID
                listItems[alertindex].ProductID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ProductID
                listItems[alertindex].Name = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].ProductName
                listItems[alertindex].Type = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Type
                listItems[alertindex].Stock = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Stock
                listItems[alertindex].Price = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Price
                listItems[alertindex].DiscountPercentage = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].DiscountPercentage
                listItems[alertindex].DiscountPrice = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].DiscountPrice
                listItems[alertindex].UnitID = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].UnitID
                listItems[alertindex].Unit = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Unit
                listItems[alertindex].Quantity = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].Quantity
                listItems[alertindex].cartCount = self.categoryproductItems1[alertindex].ProductvariantList[buttonIndex].cartCount
            self.tableView.reloadData()
            }

        
        else if(buttonIndex < wishlistid.count){
         
                listItems[wishpath].wish = "true"
                self.tableView.reloadData()
                let wishviewmodel = WishlineitemViewModel.init(productVariantID: listItems[wishpath].ProductVariantID, productID: listItems[wishpath].ProductID, wishlistID: wishlistid[buttonIndex])!
                let serializedjson  = JSONSerializer.toJson(wishviewmodel)
                print(serializedjson)
                CreateWishListItem(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST_LINEITEM, value: serializedjson)
                
            
        
            
        }
        else if(buttonIndex == wishlistid.count)
        {
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Create New Wishlist",
                message: "",
                preferredStyle: .Alert)
            
            alertController!.addTextFieldWithConfigurationHandler(
                {(textField: UITextField!) in
                    textField.placeholder = "Wishlist Name"
            })
            let action = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: {[weak self]
                    (paramAction:UIAlertAction!) in
                    if let textFields = alertController?.textFields{
                        let theTextFields = textFields as [UITextField]
                        let enteredText = theTextFields[0].text
                        print(enteredText!)
                        let wishlistviewmodel = WishViewModel.init(UserID: self!.userid, Name: enteredText!)!
                        let serializedjson  = JSONSerializer.toJson(wishlistviewmodel)
                        print(serializedjson)
                        self!.alert = 1
                        self!.CreateWishListinServer(Appconstant.WEB_API+Appconstant.CREATE_WISH_LIST, value: serializedjson)
                        
                        
                        
                    }
                })
            let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
            }
            
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!, animated: true, completion: nil)
        }
        else {
            
        }

    }
    
    func CreateWishListinServer(url : String,value : String){
        let username = self.username1
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
                self.wishlistid.removeAll()
                self.wishlistname.removeAll()
                let json = JSON(data: data!)
                for item in json["result"].arrayValue {
                    self.wishlistid.append(item["ID"].stringValue)
                    self.wishlistname.append(item["Name"].stringValue)
                }
                if(self.alert == 1){
                    self.getWishList()
                }
        }
        task.resume()
    }


    @IBAction func PlusBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!.row
        
        listItems[indexPath].cartCount = listItems[indexPath].cartCount + 1
        self.tableView.reloadData()
        
        let productmodel = Productvariant.init(ID: listItems[indexPath].ProductVariantID, ProductID: listItems[indexPath].ProductID, ProductName: listItems[indexPath].ProductName, Stock: Int(listItems[indexPath].Stock)!, Description: listItems[indexPath].Type, Unit: listItems[indexPath].Unit, Quantity: Int(listItems[indexPath].Quantity)!, Price: Float(listItems[indexPath].Price)!, DiscountPercentage: Float(listItems[indexPath].DiscountPercentage)!, DiscountPrice: Float(listItems[indexPath].DiscountPrice)!)!
        
        
        let cartadd = CartaddViewModel.init(CartID: self.cartid, ProductVariant: productmodel, Quantity: 1, MRP: Float(listItems[indexPath].Price)!, DiscountedPrice: Float(listItems[indexPath].DiscountPrice)!)!
        
        let serializedjson  = JSONSerializer.toJson(cartadd)
        
        print(serializedjson)
        print(Appconstant.WEB_API+Appconstant.ADD_TO_CART)
        
        sendrequesttoserverAddcart(Appconstant.WEB_API+Appconstant.ADD_TO_CART, value: serializedjson)
    }
    
    @IBAction func MinusBtn(sender: AnyObject) {
        let point = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)!
        
        if(listItems[indexPath.row].cartCount > 1){
            
            listItems[indexPath.row].cartCount = listItems[indexPath.row].cartCount - 1
            self.tableView.reloadData()
            let decrementmodel = DecrementViewModel.init(userId: userid, productId: listItems[indexPath.row].ProductID, productVariantId: listItems[indexPath.row].ProductVariantID)!
            
            let serializedjson  = JSONSerializer.toJson(decrementmodel)
            print(serializedjson)
            sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(userid)&productId=\(listItems[indexPath.row].ProductID)&productVariantId=\(listItems[indexPath.row].ProductVariantID)")
            
            
        }
        else if(listItems[indexPath.row].cartCount == 1){
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Are you sure want to remove item from cart?",
                message: "",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
                self.listItems[indexPath.row].cartCount = self.listItems[indexPath.row].cartCount - 1
                self.tableView.reloadData()
                let decrementmodel = DecrementViewModel.init(userId: self.userid, productId: self.listItems[indexPath.row].ProductID, productVariantId: self.listItems[indexPath.row].ProductVariantID)!
                
                let serializedjson  = JSONSerializer.toJson(decrementmodel)
                print(serializedjson)
                self.sendrequesttoserverForDecrement(Appconstant.WEB_API+Appconstant.CART_DECREMENT+"userId=\(self.userid)&productId=\(self.listItems[indexPath.row].ProductID)&productVariantId=\(self.listItems[indexPath.row].ProductVariantID)")
            }
            let action1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
            }
            alertController?.addAction(action)
            alertController?.addAction(action1)
            self.presentViewController(alertController!,
                animated: true,
                completion: nil)
            
        }

    }
    
    
    func sendrequesttoserverForDecrement(url : String){
        
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        print(url)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
        //        request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
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
                    
                }
        }
        
        task.resume()
        
    }

    
    func sendrequesttoserverAddcart(url : String,value : String)
    {
        let username = self.username1
        let password = self.password1
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic "+loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "Post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue(Appconstant.TENANT, forHTTPHeaderField: "TENANT")
        
        
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
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(Alert().alert("", message: "Item added to cart successfully"),animated: true,completion: nil)
                    }
                }
        }
        
        task.resume()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goto_product2") {
            let nextviewcontroller = segue.destinationViewController as! ProductdetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
          
                
                nextviewcontroller.productimage = self.categoryproductItems1[(indexPath?.row)!].ProductPhoto
                nextviewcontroller.productname = self.categoryproductItems1[(indexPath?.row)!].Name
                nextviewcontroller.prodesc = self.listItems[(indexPath?.row)!].Description
                nextviewcontroller.proprice = self.listItems[(indexPath?.row)!].Price
                nextviewcontroller.prodiscount = self.listItems[(indexPath?.row)!].DiscountPercentage
                nextviewcontroller.proamount = self.listItems[(indexPath?.row)!].DiscountPrice
                nextviewcontroller.prounit = self.listItems[(indexPath?.row)!].Unit
                nextviewcontroller.protype = self.listItems[(indexPath?.row)!].Type
                nextviewcontroller.proquantity = self.listItems[(indexPath?.row)!].Quantity
                nextviewcontroller.individuvalid = self.listItems[(indexPath?.row)!].ProductVariantID
                nextviewcontroller.productid = self.listItems[(indexPath?.row)!].ProductID
                nextviewcontroller.dis_price = self.listItems[(indexPath?.row)!].DiscountPrice
                nextviewcontroller.cartid = self.cartid
            nextviewcontroller.username1 = self.username1
            nextviewcontroller.password1 = self.password1
                
            
        }
    }
    func dismissKeyboard() {
        view.endEditing(true)
        cartbtn.frame = CGRectMake(522, 822, 45, 45)
    }
}
