//
//	ConfigColor.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigColor : Decodable{

	var color : String?
	var id : Int?
	var name : String?


	public static func convertToModel(response: Data?) -> ConfigColor{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigColor() 
		}
 	}


}