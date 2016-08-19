//
//  AddressPost.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/1/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class AddressPost {
    
    var UserID: Int
    var ID: Int
    var Name : String
    var AddressLine1 : String
    var AddressLine2 : String
    var City : CityModel
    var State: StateModel
    var Country: CountryModel
    var ContactNumber: ContactModel
    var Pincode: Int
    
    init?(UserID: Int, ID: Int, Name : String, AddressLine1 : String, AddressLine2 : String, City : CityModel, State: StateModel, Country: CountryModel, ContactNumber: ContactModel, Pincode: Int) {
        self.UserID = UserID
        self.ID = ID
        self.Name = Name
        self.AddressLine1 = AddressLine1
        self.AddressLine2 = AddressLine2
        self.City = City
        self.State = State
        self.Country = Country
        self.ContactNumber = ContactNumber
        self.Pincode = Pincode
    }

}
class CityModel{
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
        
    }
}
class StateModel{
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
        
    }
}
class CountryModel{
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
        
    }
}
class ContactModel{
    var Contactno: String
    init?(Contactno: String) {
        self.Contactno = Contactno
        
    }
}