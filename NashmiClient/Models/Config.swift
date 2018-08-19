//
//	Config.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class Config : Decodable{

	var about_us : String?
	var email : String?
	var id : Int?
	var intro : String?
	var mobile : String?
	var usage_rules : String?


	public static func convertToModel(response: Data?) -> Config{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return Config() 
		}
 	}


}