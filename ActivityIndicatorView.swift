
//
//  ActivityIndicatorView.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/30/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit
import Foundation

class ActivityIndicatorView {

    var view: UIView!
    
    var activityIndicator1: UIActivityIndicatorView!
    
    var title: String!
    
    init(title: String, center: CGPoint, width: CGFloat = 200.0, height: CGFloat = 50.0)
    {
        self.title = title
        
        let x = center.x - width/2.0
        let y = center.y - height/2.0
        
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = 10
        
        self.activityIndicator1 = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator1.color = UIColor.blackColor()
        self.activityIndicator1.hidesWhenStopped = false
        
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        titleLabel.text = title
        titleLabel.textColor = UIColor.blackColor()
        
        self.view.addSubview(self.activityIndicator1)
        self.view.addSubview(titleLabel)
    }
    
    func getViewActivityIndicator() -> UIView
    {
        return self.view
    }
    
    func startAnimating()
    {
        self.activityIndicator1.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopAnimating()
    {
        self.activityIndicator1.stopAnimating()

        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.view.removeFromSuperview()
        self.activityIndicator1.hidesWhenStopped = true
    }

}
