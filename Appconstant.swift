//
//  Appconstant.swift
//  SankarSuperMarket
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import Foundation
struct Appconstant
{
     static let WEB_API = "http://manjuappsapi-staging.azurewebsites.net";
//     static let  WEB_API = "http://manjuappsapi-staging-1.azurewebsites.net";
//    static let WEB_API="https://bplusapi-test.azurewebsites.net";
    static let IMAGEURL="https://manjuappsstaging.blob.core.windows.net/cdn/manjuapps_sankarsupermarket/";
    static let IMAGEURL1="https://manjuappsstaging.blob.core.windows.net/cdn/manjuapps_sankarsupermarket/";
    static let GETNOTICE="/notice/all";
    static let GETACHIEVEMENT="/achievement/all";
    static let GET_BRANCH="/branch/all"
    static let GET_OFFER="/offer/all"
    static let GET_PAGELIST="/product/listByPage"
    
//    static let TENANT="bplus_sankarsupermarket";
    static let TENANT="manjuapps_sankarsupermarket";
    static let GETCATEGORY="/category/allparentcategory";
    static let GETPRODUCT="/product/all";
    static let GETPRODUCTCATEGORY="/product/list/"
    static let GET_PRODUCTS="/product/listByPage"
    
    static let SIGNUP_URL="/user/register"
    static let AUTHENTICATE_URL="/user/authenticate"
    static let USER_CHANGE_PASSWORD="/user/changepassword"
    static let USER_FORGOT_PASSWORD="user/forgotpassword"
    
    static let ADDRESS_OPEN="/address/user/"
    static let ADDRESS_CREATE="/address/create"
    static let ADDRESS_UPDATE="/address/update"
    static let ADDRESS_DELETE="/address/delete/"
    static let UPDATE_PROFILE="/user/updateprofile"
    
    static let GET_CART_OPEN = "/cart/open/"
    static let GET_ALL_CART_LINEITEM = "/cart/"
    static let ADD_TO_CART = "/cart/item/add"
    static let UPDATE_CART_LINEITEM = "/cart/item/update"
    static let REMOVE_CART_LINEITEM = "/cart/item/remove/"
    static let PLACE_ORDER = "/cart/order"
    static let ORDER_HISTORY = "/cart/history/"
    static let REORDER_PRODUCT="/cart/reorder/"
    static let CART_DECREMENT="/cart/item/decrease?"
    
    static let GET_ALBUM="/album/all/1"
    static let GET_IMAGES="/media/all/"
    
    static let RESEND_OTP = "/user/resendotp"
    static let FORGOT_PASSCODE = "/user/forgotpassword"
    
    static let ABOUT_CONTENT = "/CMSContent/2"
    static let FAQ_ALL = "/faq/all"
    
    static let NEW_MESSAGE_THREAD = "/messagethread/create"
    static let SEND_MESSAGE = "/message/create"
    static let GET_MESSAGE_THREAD = "/messagethread/all/"
    static let GET_MESSAGE_THREAD_ID = "/message/all/"
    
    
    static let CREATE_WISH_LIST = "/wishlist/create"
    static let GET_ALL_WISH_LIST = "/wishlist/all/"
    static let DELETE_WISH_LIST = "/wishlist/delete/"
    static let GET_ALL_WISHLIST_LINEITEM = "/wishlist/"
    static let MOVE_TO_CART = "/wishlist/movetocart/"
    static let CREATE_WISH_LIST_LINEITEM = "/wishlist/createlineitem"
    static let DELETE_WISH_LIST_LINEITEM = "/wishlist/deletelineitem/"
    
    static let APPLY_COUPON = "/cart/applycoupon"
    
    static let GET_RECURRING_NAME = "/recurringOrder/all/"
    
    static var productid = 0
    static var productvariantid = 0
    
    static let textcolor = UIColor(red: 58.0/255.0, green: 88.0/255.0, blue: 38.0/255.0, alpha:1.0)
    static let btngreencolor = UIColor(red: 104.0/255.0, green: 191.0/255.0, blue: 74.0/255.0, alpha:1.0)
    static let bgcolor = UIColor(red: 249.0/255.0, green: 248.0/255.0, blue: 247.0/255.0, alpha:1.0)
    static var notificationItems = [Notification]()
    static var no_of_notification_items = -1
   static var homepage = 0
    
}