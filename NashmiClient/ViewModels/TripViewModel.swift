
import Foundation

class TripViewModel:ViewModelCore {
    enum TripStatus:Int {
        case opened = 0
        case accepted = 1
        case canceled = 2
        case rejected = 3
        case arrived = 4
        case started = 5
        case completed = 6
        case collected = 7
    }
    
    var currentTrip:DynamicType = DynamicType<TripResult>()
    var drivers:DynamicType = DynamicType<[TripDriver]>()
    var lastTrip:DynamicType = DynamicType<TripResult>()
    var estimateTrip:DynamicType = DynamicType<TripResult>()
    var created:DynamicType = DynamicType<TripResult>()
    var cancelMessage:DynamicType = DynamicType<String>()
    var message:DynamicType = DynamicType<String>()
    
    func current(_ lat:Double ,_ lng:Double) {
    
        delegate?.startLoading()
        ApiManager.instance.paramaters["lat"] = lat
        ApiManager.instance.paramaters["lng"] = lng
        ApiManager.instance.connection(.current_trip, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = CurrentTripModel.convertToModel(response: response)
            if(data.result != nil){
                self.currentTrip.value = data.result!
            }
            if data.drivers != nil {
                self.drivers.value = data.drivers!
            }
            if data.rate_last_trip != nil {
                self.lastTrip.value = data.rate_last_trip!
            }
        }
    }
    func estimate(from_lat:Double , from_lng:Double , to_lat:Double , to_lng:Double ) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters["from_lat"] = from_lat
        ApiManager.instance.paramaters["from_lng"] = from_lng
        ApiManager.instance.paramaters["to_lat"] = to_lat
        ApiManager.instance.paramaters["to_lng"] = to_lng
        ApiManager.instance.connection(.estimate_trip, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = CurrentTripModel.convertToModel(response: response)
            if(data.result != nil){
                self.estimateTrip.value = data.result!
            }
        }
    }
    func create(paramters:[String:Any]) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters = paramters
        ApiManager.instance.connection(.make_request, type: .post) { (response) in
            self.delegate?.stopLoading()
            let data = CurrentTripModel.convertToModel(response: response)
            if(data.result != nil){
                self.created.value = data.result!
            }
        }
    }
    func changeDestination(lat:Double,lng:Double) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters["to_lat"] = lat
        ApiManager.instance.paramaters["to_lng"] = lng
        ApiManager.instance.connection(.change_destination, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = CurrentTripModel.convertToModel(response: response)
            if(data.result != nil){
                self.currentTrip.value = data.result!
            }
        }
    }
    func cancel(reason:Int) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters["cancel_reason_id"] = reason
        ApiManager.instance.connection(.cancel_request, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            if(data.message != nil){
                self.cancelMessage.value = data.message!
            }
        }
    }
    func rate(trip:Int,rate:Int,comment:String?) {
        
        delegate?.startLoading()
        ApiManager.instance.paramaters["rate"] = rate
        if comment != nil {
            ApiManager.instance.paramaters["comment"] = comment!
        }
        let method = api(.rate,[trip])
        ApiManager.instance.connection(method, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            self.message.value = translate("success")
        }
    }
}


