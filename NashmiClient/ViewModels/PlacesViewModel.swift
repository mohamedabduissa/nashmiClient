
import Foundation

class PlacesViewModel:ViewModelCore {
    
    var places:DynamicType = DynamicType<[PlacesResult]>()
    var message:DynamicType = DynamicType<String>()

    func fetchData() {
    
        delegate?.startLoading()
        ApiManager.instance.connection(.client_places, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = PlacesModel.convertToModel(response: response)
            if data.result != nil {
                self.places.value = data.result!
            }
        }
    }
    
    func create(lat:Double , lng:Double , name:String) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters["lat"] = lat
        ApiManager.instance.paramaters["lng"] = lng
        ApiManager.instance.paramaters["name"] = name
        ApiManager.instance.connection(.client_places, type: .post) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            if data.result != nil {
                self.message.value = data.result!
            }
        }
    }
    
    func update(place:Int,lat:Double , lng:Double , name:String) {
        ApiManager.instance.paramaters["lat"] = lat
        ApiManager.instance.paramaters["lng"] = lng
        ApiManager.instance.paramaters["name"] = name
        delegate?.startLoading()
        let method = api(.client_places , [place])
        ApiManager.instance.connection(method, type: .put) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            if data.result != nil {
                self.message.value = data.result!
            }
        }
    }
    
    func delete(place:Int) {
        
        delegate?.startLoading()
        let method = api(.client_places , [place])
        ApiManager.instance.connection(method, type: .delete) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            if data.result != nil {
                self.message.value = data.result!
            }
        }
    }
    

}


