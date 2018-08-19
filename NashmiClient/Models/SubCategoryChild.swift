//
//	SubCategoryChild.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 



class SubCategoryChild : Decodable{

	var description : String?
	var fixed_price : Int?
	var id : Int?
	var image : String?
	var name : String?
	var parent_id : Int?


	public static func convertToModel(response: Data?) -> SubCategoryChild{
 		do{ 
 			let data = try JSONDecoder().decode(self, from: response!)
 			return data 
 		}catch{ 
 			return SubCategoryChild() 
		}
 	}


}
