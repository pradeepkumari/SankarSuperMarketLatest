//
//  DBHelper.swift
//  YAP Customer
//
//  Created by Admin on 4/7/16.
//  Copyright © 2016 yap. All rights reserved.
//

import Foundation

class DBHelper {
    
    var databasePath = NSString()
    func opensupermarketDB()
    {
        let filemgr = NSFileManager.defaultManager()
        //     let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        //    let docsDir = dirPaths[0]
        let databaseURL = NSURL(fileURLWithPath:NSTemporaryDirectory()).URLByAppendingPathComponent("supermarket.db")
        databasePath = databaseURL.absoluteString
        //databasePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("yapcustomer.db")
        // databasePath = docsDir.stringByAppendingPathComponent("yapcustomer.db")
        //   stringByAppendingPathComponent("yapcustomer.db")
        print(databasePath as String)
        if !filemgr.fileExistsAtPath(databasePath as String)
        {
            
            CreateTable();
        }
        
    }
    
    internal func CreateTable() {
        let supermarketDB = FMDatabase(path: databasePath as String)
        
        if supermarketDB.open() {
            let signup_table = "CREATE TABLE IF NOT EXISTS SIGNUP (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, EMAILID TEXT, MOBILENUMBER TEXT, PASSWORD TEXT, CONFIRMPASSWORD TEXT)"
            if !supermarketDB.executeStatements(signup_table) {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            
            let login_table = "CREATE TABLE IF NOT EXISTS LOGIN (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERID INTEGER, NAME TEXT, EMAILID TEXT, PASSWORD TEXT, PHONENUMBER INTEGER, NOTIFICATIONVALUE INTEGER)"
            if !supermarketDB.executeStatements(login_table) {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            let product_table = "CREATE TABLE IF NOT EXISTS CARTITEMS(ID INTEGER PRIMARY KEY AUTOINCREMENT, INDIVIDUALID INTEGER, PID INTEGER,  PRODUCTNAME TEXT, QUANTITY TEXT, PRICE TEXT, IMAGEURL TEXT, DISCOUNTPERCENT DOUBLE, DISCOUNTPRICE DOUBLE, CARTLINEID INTEGER)"
            if !supermarketDB.executeStatements(product_table) {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            let address_table = "CREATE TABLE IF NOT EXISTS ADDRESS(ID INTEGER PRIMARY KEY AUTOINCREMENT, ADDRESSID INTEGER, NAME TEXT, ADDRESS1 TEXT, ADDRESS2 TEXT, CITY TEXT, STATE TEXT, COUNTRY TEXT, PINCODE TEXT, MOBILENO TEXT)"
            if !supermarketDB.executeStatements(address_table) {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            let category_table = "CREATE TABLE IF NOT EXISTS CATEGORY(ID INTEGER PRIMARY KEY AUTOINCREMENT, CATEGORYID INTEGER, NAME TEXT, imagePath TEXT,CategoryIcon TEXT)"
            if !supermarketDB.executeStatements(category_table) {
                print("Error: \(supermarketDB.lastErrorMessage())")
            }
            
            
            
            
            supermarketDB.close()
        }

        
    }
    

}

