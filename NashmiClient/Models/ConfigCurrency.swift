//
//	ConfigCurrency.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigCurrency : Decodable{

	var id : Int?
	var name : String?
	var symbol : String?


	public static func convertToModel(response: Data?) -> ConfigCurrency{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigCurrency() 
		}
 	}


}
