//
//	ConfigResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ConfigResult : Decodable{

	var brands : [ConfigBrand]?
	var cancel_reasons : [ConfigCancelReason]?
	var categories : [ConfigCategory]?
	var colors : [ConfigColor]?
	var config : Config?
	var countries : [ConfigCountry]?
	var sliders : [String]?


	public static func convertToModel(response: Data?) -> ConfigResult{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ConfigResult() 
		}
 	}


}