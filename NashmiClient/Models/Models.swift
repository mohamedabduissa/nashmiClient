//
//	Models.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class Models : Decodable{

	var result : [ModelsResult]?
	var statusCode : Int?
	var statusText : String?


	public static func convertToModel(response: Data?) -> Models{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return Models() 
		}
 	}


}