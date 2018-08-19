//
//	ConfigModel.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigModel : Decodable{

	var result : ConfigResult?
	var statusCode : Int?
	var statusText : String?


	public static func convertToModel(response: Data?) -> ConfigModel{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigModel() 
		}
 	}


}