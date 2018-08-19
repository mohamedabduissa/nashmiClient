//
//	SubCategoryModel.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class SubCategoryModel : Decodable{

	var result : [SubCategoryResult]?
	var statusCode : Int?
	var statusText : String?


	public static func convertToModel(response: Data?) -> SubCategoryModel{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return SubCategoryModel() 
		}
 	}


}