//
//  PopoverViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 9/14/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    var weeklyValue = ["","","","","","",""]
    var SelectedDays = [String]()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weekView: UIView!    
    @IBOutlet weak var monthView: UIView!

   
    @IBOutlet var btnArray: [UIButton]!
    
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thur: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.view.addSubview(mainView)
        self.mainView.addSubview(weekView)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func initialize(){
        sunday.backgroundColor = UIColor.whiteColor()
        sunday.layer.borderWidth = 1
        sunday.layer.borderColor = UIColor.blackColor().CGColor
        monday.backgroundColor = UIColor.whiteColor()
        monday.layer.borderWidth = 1
        monday.layer.borderColor = UIColor.blackColor().CGColor
        tues.backgroundColor = UIColor.whiteColor()
        tues.layer.borderWidth = 1
        tues.layer.borderColor = UIColor.blackColor().CGColor
        wed.backgroundColor = UIColor.whiteColor()
        wed.layer.borderWidth = 1
        wed.layer.borderColor = UIColor.blackColor().CGColor
        thur.backgroundColor = UIColor.whiteColor()
        thur.layer.borderWidth = 1
        thur.layer.borderColor = UIColor.blackColor().CGColor
        friday.backgroundColor = UIColor.whiteColor()
        friday.layer.borderWidth = 1
        friday.layer.borderColor = UIColor.blackColor().CGColor
        saturday.backgroundColor = UIColor.whiteColor()
        saturday.layer.borderWidth = 1
        saturday.layer.borderColor = UIColor.blackColor().CGColor
//        for(var i = 0; i<31; i++){
//            print(i)
//            btnArray[i].backgroundColor = UIColor.whiteColor()
//            btnArray[i].layer.borderColor = UIColor.blackColor().CGColor
//        }

    }

    @IBAction func BtnAction(sender: AnyObject) {
        //Close button action
        self.view.removeFromSuperview()
  
    }

    @IBAction func sundayBtn(sender: AnyObject) {
        if sunday.backgroundColor == UIColor.whiteColor() {
            sunday.backgroundColor = Appconstant.btngreencolor
            weeklyValue[0] = "Sunday"
        }
        else{
            sunday.backgroundColor = UIColor.whiteColor()
            weeklyValue[0] = ""
        }
    }
    
    @IBAction func mondayBtn(sender: AnyObject) {
        if monday.backgroundColor == UIColor.whiteColor() {
            monday.backgroundColor = Appconstant.btngreencolor
            weeklyValue[1] = "Monday"
        }
        else{
            monday.backgroundColor = UIColor.whiteColor()
            weeklyValue[1] = ""
        }
    }
   
    @IBAction func tuesdayBtn(sender: AnyObject) {
        if tues.backgroundColor == UIColor.whiteColor() {
            tues.backgroundColor = Appconstant.btngreencolor
            weeklyValue[2] = "Tuesday"
        }
        else{
            tues.backgroundColor = UIColor.whiteColor()
            weeklyValue[2] = ""
        }
    }
    
    @IBAction func wednesdayBtn(sender: AnyObject) {
        if wed.backgroundColor == UIColor.whiteColor() {
            wed.backgroundColor = Appconstant.btngreencolor
            weeklyValue[3] = "Wednesday"
        }
        else{
            wed.backgroundColor = UIColor.whiteColor()
            weeklyValue[3] = ""
        }
    }
    
    @IBAction func thursdayBtn(sender: AnyObject) {
        if thur.backgroundColor == UIColor.whiteColor() {
            thur.backgroundColor = Appconstant.btngreencolor
            weeklyValue[4] = "Thursday"
        }
        else{
            thur.backgroundColor = UIColor.whiteColor()
            weeklyValue[4] = ""
        }
    }
    
    @IBAction func fridayBtn(sender: AnyObject) {
        if friday.backgroundColor == UIColor.whiteColor() {
            friday.backgroundColor = Appconstant.btngreencolor
            weeklyValue[5] = "Friday"
        }
        else{
            friday.backgroundColor = UIColor.whiteColor()
            weeklyValue[5] = ""
        }
    }
    
    @IBAction func saturdayBtn(sender: AnyObject) {
        if saturday.backgroundColor == UIColor.whiteColor() {
            saturday.backgroundColor = Appconstant.btngreencolor
            weeklyValue[6] = "Sarurday"
        }
        else{
            saturday.backgroundColor = UIColor.whiteColor()
            weeklyValue[6] = ""
        }
    }
    
    
    
    
    
    
    
    @IBAction func OkBtnAction(sender: AnyObject) {
        for(var i = 0; i<7; i++){
            if(weeklyValue[i] != ""){
                self.SelectedDays.append(weeklyValue[i])
            }
            
        }
        print(weeklyValue)
    }
    
}
