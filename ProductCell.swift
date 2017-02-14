//
//  ProductCell.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productimg: UIImageView!
    
    @IBOutlet weak var productname: UILabel!

    @IBOutlet var typelabel: UILabel!
    
    @IBOutlet weak var cartbtn: UIButton!
    
     @IBOutlet weak var typeBtn: UIButton!
    var categoryproductItems = [CategoryProduct]()
    var productvariantItems = [ProductVariantList]()
//        pickerView.reloadAllComponents()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
 
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }



}


