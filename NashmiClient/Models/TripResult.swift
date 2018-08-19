//
//	TripResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class TripResult : Decodable{
    
    
	var category_id : Int?
	var category_name : String?
	var client_comment : String?
	var client_rate : Int?
    var driver_comment : String?
    var driver_rate : Int?
	var commission : Int?
	var created_at : String?
	var discount : Int?
	var distance : Int?
	var driver : TripDriver?
	var end_date : String?
	var fare_estimation : String?
	var from_lat : Double?
	var from_lng : Double?
	var from_location : String?
	var id : Int?
	var payment_method : Int?
	var payment_method_text : String?
	var statistics : TripStatistic?
	var status : Int?
	var status_text : String?
	var tax : Int?
	var time_estimation : String?
	var to_lat : Double?
	var to_lng : Double?
	var to_location : String?
	var total_price : Int?
	var trip_price : Int?
	var type : String?


}
