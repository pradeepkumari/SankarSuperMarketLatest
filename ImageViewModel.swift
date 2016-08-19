//
//  ImageViewModel.swift
//  SankarSuperMarket
//
//  Created by Admin on 7/6/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation

class ImageViewModel {
    var ID: String
    var Image: String
    init?(ID: String, Image: String){
        self.ID = ID
        self.Image = Image
    }

}
