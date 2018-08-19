//
//	TripCar.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class TripCar : Decodable{

	var brand_id : Int?
	var brand_name : String?
	var color : String?
	var color_id : Int?
	var color_name : String?
	var id : Int?
	var model_id : Int?
	var model_name : String?
	var year : Int?


	public static func convertToModel(response: Data?) -> TripCar{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return TripCar() 
		}
 	}


}