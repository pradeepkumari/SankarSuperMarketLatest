//
//  ProductDescriptionViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ProductdescriptionViewController: UIViewController {
    
    var productimage: UIImage?
    @IBOutlet weak var descriptionimg: UIImageView!
    
    @IBOutlet weak var proname: UILabel!
    
    @IBOutlet weak var prodescription: UILabel!
    
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var amount: UILabel!
   
    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var addtoCart: UIButton!
    @IBOutlet weak var quantity: UILabel!
    
    var productname = ""
    var prodesc = ""
    var proprice = ""
    var prodiscount = ""
    var proamount = ""
    var prounit = ""
    var protype = ""
    var proquantity = ""
    var serverquantity = 1
    var cartid = 0
    var individuvalid = 0
    var productid = 0
    var dis_price = ""
    var username1 = ""
    var password1 = ""
    var cartcountnumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cartbtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 80, 45, 45)
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
        
        cartbtn.userInteractionEnabled = true
        cartbtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cartbtn)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        addtoCart.layer.cornerRadius = 5
        descriptionimg.image = self.productimage
        price.text = self.proprice
        discount.text = self.prodiscount + "%"
        amount.text = self.proamount
        quantity.text = self.protype
        self.navigationItem.title = self.productname
    }
    
    
    @IBAction func AddToCartBtnAction(sender: AnyObject) {
        Reachability().checkconnection()
        self.cartcountnumber += 1
        self.cartbtn.setTitle("\(self.cartcountnumber)", forState: .Normal)
        let productmodel = Productvariant.init(ID: self.individuvalid, ProductID: self.productid, ProductName: self.productname, Stock: Int(self.proquantity)!, Description: self.protype, Unit: self.prounit, Quantity: Int(self.proquantity)!, Price: Float(self.proprice)!, DiscountPercentage: Float(self.prodiscount)!, DiscountPrice: Float(self.dis_price)!)!
        
        
        
        let cartadd = CartaddViewModel.init(CartID: self.cartid, ProductVariant: productmodel, Quantity: self.serverquantity, MRP: Float(self.proprice)!, DiscountedPrice: Float(self.dis_price)!)!
        
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
