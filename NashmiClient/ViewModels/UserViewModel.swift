
import Foundation

class UserViewModel:ViewModelCore {
    
    
    var model:DynamicType = DynamicType<UserRoot>()
    var message:DynamicType = DynamicType<String>()
    
    func fetchData() {
        delegate?.startLoading()
        ApiManager.instance.connection(.configs, type: .get) { (response) in
            self.delegate?.stopLoading()
            
        }
    }
    
    
    func login(username:String , password:String) {
        ApiManager.instance.paramaters["username"] = username
        ApiManager.instance.paramaters["password"] = password
        
        delegate?.startLoading()
        ApiManager.instance.connection(.login, type: .post) { (response) in
            self.delegate?.stopLoading()
            let data = UserRoot.convertToModel(response: response)
            if data.access_token != nil {
                data.storeInDefault()
                self.model.value = data
            }
        }
    }
    func register(paramters:[String:String]) {
        ApiManager.instance.paramaters = paramters
        
        delegate?.startLoading()
        ApiManager.instance.connection(.register, type: .post) { (response) in
            self.delegate?.stopLoading()
            let data = UserRoot.convertToModel(response: response)
            if data.access_token != nil {
                data.storeInDefault()
                self.model.value = data
            }
        }
    }
    func activate(code:Int) {
        
        let method = api(.activate,[code])
        delegate?.startLoading()
        ApiManager.instance.connection(method, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = BaseModel.convertToModel(response: response)
            if data.message != nil {
              self.message.value = data.message
            }
        }
    }
    func update(paramters:[String:String]) {
        ApiManager.instance.paramaters = paramters
        
        delegate?.startLoading()
        ApiManager.instance.connection(.update, type: .put) { (response) in
            self.delegate?.stopLoading()
            let data = UserRoot.convertToModel(response: response)
            if data.result != nil {
                data.storeInDefault()
                self.model.value = data
            }
        }
    }
}


