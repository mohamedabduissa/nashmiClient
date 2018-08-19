//
//	SubCategoryResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class SubCategoryResult : Decodable{

	var childs : [SubCategoryChild]?
	var description : String?
	var id : Int?
	var image : String?
	var name : String?


	public static func convertToModel(response: Data?) -> SubCategoryResult{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return SubCategoryResult() 
		}
 	}


}
