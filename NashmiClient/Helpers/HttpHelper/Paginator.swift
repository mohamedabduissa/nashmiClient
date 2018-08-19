//
//  Paginator.swift
//  FashonDesign
//
//  Created by mohamed abdo on 5/31/18.
//  Copyright © 2018 Atiaf. All rights reserved.
//

import Foundation
protocol Paginator : class {
    func paginate()
    func incresePaginate()
    func resetPaginate()
    func stopPaginate()
    func checkPaginator(respond:Array<Any>?)
}

fileprivate var paginatorFile:Int = 1
fileprivate var paginatorStopFile:Bool = false
fileprivate var paginatorLimitFile = 10

extension Paginator{
    var paginator:Int{
        set{
            paginatorFile = newValue
        }get{
            return paginatorFile
        }
    }
    var paginatorStop:Bool{
        set{
            paginatorStopFile = newValue
        }get{
            return paginatorStopFile
        }
    }
    var paginatorLimit:Int{
        set{
            paginatorLimitFile = newValue
        }get{
            return paginatorLimitFile
        }
    }    
    func paginate()  {
       ApiManager.instance.paramaters["page"] = paginator
        if(ApiManager.instance.paramaters["custom_page"] != nil){
            ApiManager.instance.paramaters["page"] = ApiManager.instance.paramaters["custom_page"]
        }
    }
    func incresePaginate() {
        paginator = paginator+1
    }
    func resetPaginate()  {
        paginator = 1
        paginatorStop = false
        ApiManager.instance.resetObject()
    }
    func stopPaginate()  {
        paginatorStop = true
    }
    func runPaginate()  {
        paginatorStop = false
    }
    func checkPaginator(respond:Array<Any>?){
        
        if let array = respond{
            if array.count == 0 || array.count < ApiManager.instance.paginatorLimit{
                self.stopPaginate()
            }else{
                self.runPaginate()
            }
        }
        print(self.paginatorStop)
    }
}
