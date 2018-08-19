
import Foundation

class SettingViewModel:ViewModelCore {
    
    
    var setting:DynamicType = DynamicType<ConfigResult>()
    
    func fetchData() {
        delegate?.startLoading()
        ApiManager.instance.connection(.configs, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = ConfigModel.convertToModel(response: response)
            if(data.result != nil){
                self.setting.value = data.result!
            }
        }
    }
    
    

}


