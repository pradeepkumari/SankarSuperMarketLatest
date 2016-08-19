
//
//  CheckBox.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/21/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    let checkedImage = UIImage(named: "checked.png")
    let unCheckedImage = UIImage(named: "unchecked.png")
    
    //bool property
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    func buttonClicked(sender:UIButton) {
        if(sender == self) {
            if isChecked == true {
                isChecked = false
            }else{
                isChecked = true
            }
        }
    }
}
