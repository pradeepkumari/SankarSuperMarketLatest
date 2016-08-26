
//
//  ProductdetailViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 8/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ProductdetailViewController: UIViewController {
    
    var productimage: UIImage!
    var productname = ""
    var prodesc = ""
    var proprice = ""
    var prodiscount = ""
    var proamount = ""
    var prounit = ""
    var protype = ""
    var proquantity = ""
    var individuvalid = 0
    var productid = 0
    var dis_price = ""
    var cartid = 0
    var username1 = ""
    var password1 = ""
    var cartcountnumber = 0
    
 
    @IBOutlet weak var productimg: UIImageView!
    @IBOutlet weak var productnamelbl: UILabel!

    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var offeramountlbl: UILabel!
    
    @IBOutlet weak var quantitylbl: UILabel!
    
    @IBOutlet weak var AddtoCart: UIButton!
    var home: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddtoCart.layer.cornerRadius = 5
//        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
        self.cartbtn.layer.cornerRadius = 23
        self.cartbtn.layer.shadowOpacity = 1
        self.cartbtn.layer.shadowRadius = 2
        self.cartbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.cartbtn.layer.shadowColor = UIColor.grayColor().CGColor
        self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        cartbtn.titleEdgeInsets = UIEdgeInsetsMake(5, -35, 0, 0)
        cartbtn.setImage(UIImage(named: "Cartimg.png"), forState: UIControlState.Normal)
        cartbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4.5, 3, 0)
        cartbtn.tintColor = UIColor.whiteColor()
        cartbtn.backgroundColor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
//        cartbtn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        //        cartbtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)

        pricelbl.text = self.proprice
        discount.text = self.prodiscount
        offeramountlbl.text = self.proamount
        quantitylbl.text = self.protype
        productimg.image = productimage
        // Do any additional setup after loading the view.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem



        self.navigationItem.title = self.productname
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func action(){
        let homeview = HomeViewController()
        self.presentViewController(homeview, animated: true, completion: nil)
    }

    @IBAction func AddtoCartBtn(sender: AnyObject) {
        Reachability().checkconnection()
        self.cartcountnumber += 1
        self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        let productmodel = Productvariant.init(ID: self.individuvalid, ProductID: self.productid, ProductName: self.productname, Stock: Int(self.proquantity)!, Description: self.protype, Unit: self.prounit, Quantity: Int(self.proquantity)!, Price: Float(self.proprice)!, DiscountPercentage: Float(self.prodiscount)!, DiscountPrice: Float(self.dis_price)!)!
        
        
        
        let cartadd = CartaddViewModel.init(CartID: self.cartid, ProductVariant: productmodel, Quantity: 1, MRP: Float(self.proprice)!, DiscountedPrice: Float(self.dis_price)!)!
        
        let serializedjson  = JSONSerializer.toJson(cartadd)
        
        
        sendrequesttoserverAddcart(Appconstant.WEB_API+Appconstant.ADD_TO_CART, value: serializedjson)
        
        
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
                else{
                    
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                    
                    
                    self.presentViewController(Alert().alert("", message: "Item added to cart successfully"),animated: true,completion: nil)
                }
                
        }
        
        task.resume()
        
    }

}
