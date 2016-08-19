//
//  AddressViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/24/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class AddressViewModel
{
    var UserID: Int
    var Name : String
    var AddressLine1 : String
    var AddressLine2 : String
    var City : CityViewModel
    var State : StateViewModel
    var Country : CountryViewModel
    var ContactNumber: ContactViewModel
    var Pincode: Int
    
    init?(UserID: Int, Name : String, AddressLine1 : String, AddressLine2 : String, City: CityViewModel, State: StateViewModel, Country: CountryViewModel, ContactNumber: ContactViewModel, Pincode: Int)
    {
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
class CityViewModel {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class StateViewModel {
    var Name : String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class CountryViewModel{
    var Name: String
    init?(Name: String)
    {
        self.Name = Name
    }
}
class ContactViewModel {
    var Contactno: String
    var userprofile: UserProfile
    init?(Contactno: String, userprofile: UserProfile) {
        self.Contactno = Contactno
        self.userprofile = userprofile
    }
}
class  UserProfile {
    var ID: Int
    init?(ID: Int) {
        self.ID = ID
    }
}