//
//  Constants.swift
//  homeCheif
//
//  Created by mohamed abdo on 4/21/18.
//  Copyright © 2018 Atiaf. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
struct Constants{
    
    static let locale = LocalizationHelper.getLocale()
    static var login:String{
        get{
            Constants.storyboard = Storyboards.main.rawValue
            return "LoginNav"
        }
    }
    static var storyboard = Storyboards.main.rawValue
    static let url = "http://173.236.24.193/~nashmi/api/v1/"
    static let companyUrl = "http://173.236.24.193/~nashmi"
    static let copyrightUrl = ""
    static let itunesURL = "itms-apps://itunes.apple.com/app/id1330387425"
    static let version = "v1"
    static let deviceType = "2"
    static let deviceToken = "deviceToken"
    static let deviceId = UIDevice.current.identifierForVendor!.uuidString
    static let googleAPI = "AIzaSyCGKTEvpfIbHSLZBvckDG06-KKQOGD6wyo"
    static let googleRoutesAPI = "AIzaSyDP115w2CRwFjSQDiCzYRJ4jFTu1IHS2qI"
    
    static let mainColorRGB = UIColor(red: 244/255, green: 154/255, blue: 0/255, alpha: 1)
    static let textColorRGB = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    static let borderColorRGB = UIColor.init(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
    static let underlineRGB = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
    
    static var splash:Void!
    static func sleep(time:TimeInterval){
        Constants.splash = Thread.sleep(forTimeInterval: time)
        
    }
    static func initAppDelegate(){
        initLang()
        //Constants.sleep(time: 3)
        //Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(Constants.googleAPI)
        GMSPlacesClient.provideAPIKey(Constants.googleAPI)
    }
    
    
}


public enum Storyboards:String{
    case main = "Main"
}


public enum PaymentsMethod :String{
    case cash
    case paypal
    case credit
}

public enum Apis:String {
    case configs
    case models
    case sub_categories
    case token = "refresh/token"
    case forget_password = "password/reset"
    case reset_password = "password/verify"
    case login = "client/login"
    case register = "client/register"
    case social = "client/register/social"
    case update = "client/update"
    case logout
    case activate
    case client_places
    case client_contacts
    case default_contact = "client_contacts/default"
    case estimate_trip = "trips/estimate"
    case current_trip = "trips/client/current"
    case make_request = "trips"
    case change_destination = "client/trip/change/destination"
    case cancel_request = "trips/cancel"
    case accept_price = "trips/accept/price"
    case reject_price = "trips/reject/request"
    case rate = "client/trip/rate"
    case history = "client/history"
    case notifications = "client/notifications"
   
}


