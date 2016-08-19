//
//  AddressViewModelpost.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/29/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class AddressViewModelPost
{
    var UserID: Int
    var ID: Int
    var Name : String
    var AddressLine1 : String
    var AddressLine2 : String
    var City : CityViewModel1
    var State : StateViewModel1
    var Country : CountryViewModel1
    var ContactNumber: ContactViewModel1
    var Pincode: Int
    
    init?(UserID: Int, ID: Int, Name : String, AddressLine1 : String, AddressLine2 : String, City: CityViewModel1, State: StateViewModel1, Country: CountryViewModel1, ContactNumber: ContactViewModel1, Pincode: Int)
    {
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
class CityViewModel1 {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name

    }
}
class StateViewModel1 {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class CountryViewModel1{
    var Name: String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class ContactViewModel1 {
    var Contactno: String
    init?(Contactno: String) {
        self.Contactno = Contactno
     
    }
}

