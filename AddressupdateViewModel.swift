//
//  AddressupdateViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/15/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class AddressupdateViewModel {
    var ID: String
    var UserID: String
    var Name : String
    var AddressLine1 : String
    var AddressLine2 : String
    var City : CityViewModel2
    var State : StateViewModel2
    var Country : CountryViewModel2
    var ContactNumber: ContactViewModel2
    var Pincode: Int
    
    init?(ID: String, UserID: String, Name : String, AddressLine1 : String, AddressLine2 : String, City: CityViewModel2, State: StateViewModel2, Country: CountryViewModel2, ContactNumber: ContactViewModel2, Pincode: Int)
    {
        self.ID = ID
        self.UserID = UserID
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
class CityViewModel2 {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class StateViewModel2 {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class CountryViewModel2{
    var Name: String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class ContactViewModel2 {
    var Contactno: String
    var userprofile: UserProfile2
    init?(Contactno: String, userprofile: UserProfile2) {
        self.Contactno = Contactno
        self.userprofile = userprofile
    }
}
class  UserProfile2 {
    var ID: Int
    init?(ID: Int) {
        self.ID = ID
    }
}
