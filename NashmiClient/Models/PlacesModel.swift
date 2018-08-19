//
//	SubCategoryResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 


class PlacesModel : Decodable{
    
    var result:[PlacesResult]?
    
    public static func convertToModel(response: Data?) -> PlacesModel{
        do{
            let data = try JSONDecoder().decode(self, from: response!)
            return data
        }catch{
            return PlacesModel()
        }
    }
}
class PlacesResult : Decodable{
    
    var id : Int?
    var lat : Double?
    var lng : Double?
    var location : String?
    var name : String?
    
}
