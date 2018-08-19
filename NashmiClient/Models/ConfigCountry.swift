//
//	ConfigCountry.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigCountry : Decodable{

	var code : String?
	var currency : ConfigCurrency?
	var id : Int?
	var image : String?
	var name : String?


	public static func convertToModel(response: Data?) -> ConfigCountry{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigCountry() 
		}
 	}


}