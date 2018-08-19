//
//	TripCurrentTripModel.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class CurrentTripModel : Decodable{

	var drivers : [TripDriver]?
	var rate_last_trip : TripResult?
	var result : TripResult?
	var statusCode : Int?
	var statusText : String?


	public static func convertToModel(response: Data?) -> CurrentTripModel{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return CurrentTripModel() 
		}
 	}


}
