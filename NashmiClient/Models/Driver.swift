//
//	SubCategoryResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 

class Driver : Decodable{
    
    var admin_credit : Int?
    var car : DriverCar?
    var car_license_img : String?
    var category_id : Int?
    var category_name : String?
    var driving_license_img : String?
    var his_credit : Int?
    var id : Int?
    var lat : String?
    var lng : String?
    var online : Bool?
    var statistics : DriverStatistic?
    var total_credit : Int?
    
}
class DriverStatistic : Decodable{
    var online_hours : Int?
    var today_earned : Int?
    var today_trips : Int?
}

