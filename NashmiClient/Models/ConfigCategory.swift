//
//	ConfigCategory.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigCategory : Decodable{

	var description : String?
	var has_sub : Bool?
	var id : Int?
	var img : String?
	var name : String?


	public static func convertToModel(response: Data?) -> ConfigCategory{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigCategory() 
		}
 	}


}
