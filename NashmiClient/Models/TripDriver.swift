//
//	TripDriver.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class TripDriver : Decodable,Equatable{
    static func == (lhs: TripDriver, rhs: TripDriver) -> Bool {
        return true
    }
    
    
	var admin_credit : Int?
	var car : TripCar?
    //var car_license_img : String?
//    var category_id : Int?
//    var category_image : String?
//    var category_name : String?
	//var driving_license_img : String?
	var his_credit : Int?
	var id : Int?
	var lat : String?
	var lng : String?
	var online : Bool?
	var rate : String?
	var statistics : TripStatistic?
	var total_credit : Int?
	var country_code : String?
	var country_id : Int?
	var currency : String?
	var driver : TripDriver?
	var email : String?
	var first_name : String?
	var image : String?
	var last_name : String?
	var mobile : String?

}
