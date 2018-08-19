//
//	ModelsResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class ModelsResult : Decodable{

	var id : Int?
	var name : String?


	public static func convertToModel(response: Data?) -> ModelsResult{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return ModelsResult() 
		}
 	}


}