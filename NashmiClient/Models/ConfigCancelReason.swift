//
//	ConfigCancelReason.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigCancelReason : Decodable{

	var id : Int?
	var name : String?


	public static func convertToModel(response: Data?) -> ConfigCancelReason{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigCancelReason() 
		}
 	}


}