
import Foundation

class CategoryViewModel:ViewModelCore {
    
    
    var model:DynamicType = DynamicType<[SubCategoryResult]>()
    
    func fetchData(_ category:Int) {
        delegate?.startLoading()
        let method = api(.sub_categories,[category])
        ApiManager.instance.connection(method, type: .get) { (response) in
            self.delegate?.stopLoading()
            let data = SubCategoryModel.convertToModel(response: response)
            if(data.result != nil){
                self.model.value = data.result!
            }
        }
    }
    
    

}


