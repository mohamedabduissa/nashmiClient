//
//	ConfigBrand.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigBrand : Decodable{

	var id : Int?
	var image : String?
	var name : String?


	public static func convertToModel(response: Data?) -> ConfigBrand{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigBrand() 
		}
 	}


}