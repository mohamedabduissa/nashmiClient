//
//	SubCategoryResult.swift
//Created By Abdu Exporter. All rights reserved.


import Foundation 

class PaymentMethodModel {
    var id:Int?
    var image:UIImage?
    var name:String?
    var index:PaymentsMethod?
    init(id:Int? , image:UIImage?,name:String? ,index:PaymentsMethod?) {
        self.id = id
        self.image = image
        self.name = name
        self.index = index
    }
}
