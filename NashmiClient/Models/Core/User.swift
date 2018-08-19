
import Foundation



class UserRoot : Decodable{

    var result : User?
    var errors : Errors?
    var expires_in : Int?
    var access_token : String?
    var refresh_token : String?
    var message : String?
    var json:String?
    
    init() {
        self.getUser()
    }
    struct Static {
        static var instance: UserRoot?
    }
    
    class var instance : UserRoot {
        
        if(Static.instance == nil) {
            Static.instance = UserRoot()
        }
        Static.instance?.getUser()
        return Static.instance!
    }
    
   
    public static func isLogin()->Bool {
        if UserRoot.instance.access_token != nil {
            return true
        }else{
            return false
        }
    }
    public static func convertToModel(response: Data?) -> UserRoot{
        do{
            let data = try JSONDecoder().decode(self, from: response!)
            data.json = String(data: response!, encoding: .utf8)
            return data
        }catch{
            print(error.localizedDescription)
            return UserRoot()
        }
    }
    
    public static func getUserFromCache()-> UserRoot{
        let data = UserRoot.instance.json?.data(using: .utf8)
        let user = UserRoot.convertToModel(response: data)
        return user
    }
    
    
    
 
    public func getUser(){
    
        self.result = User()
        self.access_token = UserDefaults.standard.string(forKey: "access_token")
        self.refresh_token = UserDefaults.standard.string(forKey: "refresh_token")
        self.expires_in = UserDefaults.standard.integer(forKey: "expires_in")
        self.result?.active = UserDefaults.standard.string(forKey: "active")
        self.result?.activation_code = UserDefaults.standard.integer(forKey: "activation_code")
        self.result?.client_credit = UserDefaults.standard.integer(forKey: "client_credit")
        self.result?.country_code = UserDefaults.standard.string(forKey: "country_code")
        self.result?.country_id = UserDefaults.standard.integer(forKey: "country_id")
        self.result?.currency = UserDefaults.standard.string(forKey: "currency")
        self.result?.image = UserDefaults.standard.string(forKey: "image")
        self.result?.email = UserDefaults.standard.string(forKey: "email")
        self.result?.first_name = UserDefaults.standard.string(forKey: "first_name")
        self.result?.last_name = UserDefaults.standard.string(forKey: "last_name")
        self.result?.mobile = UserDefaults.standard.string(forKey: "mobile")
        self.result?.payment_method = UserDefaults.standard.string(forKey: "payment_method")
        self.result?.payment_method_text = UserDefaults.standard.string(forKey: "payment_method_text")
        self.json = UserDefaults.standard.string(forKey: "json")

    }
    public func storeInDefault() {
        let defaults = UserDefaults.standard
        if let _ = access_token{
            defaults.set(self.access_token , forKey: "access_token")
            defaults.set(self.expires_in, forKey: "expires_in")
            defaults.set(self.refresh_token, forKey: "refresh_token")
        }
        guard let data = self.result else {return}
        
        defaults.set(true, forKey: "LOGIN")
        defaults.set(json, forKey: "json")
        defaults.set(Date(), forKey: "LastLogin")
        defaults.set(data.email , forKey: "email")
        defaults.set(data.first_name, forKey: "first_name")
        defaults.set(data.last_name, forKey: "last_name")
        defaults.set(data.image, forKey: "image")
        defaults.set(data.mobile, forKey: "mobile")
        defaults.set(data.active, forKey: "active")
        defaults.set(data.activation_code, forKey: "activation_code")
        defaults.set(data.client_credit, forKey: "client_credit")
        defaults.set(data.country_code, forKey: "country_code")
        defaults.set(data.country_id, forKey: "country_id")
        defaults.set(data.currency, forKey: "currency")
        defaults.set(data.email, forKey: "email")
        defaults.set(data.payment_method, forKey: "payment_method")
        defaults.set(data.payment_method_text, forKey: "payment_method_text")
        
    }
    public static func removeCacheingDefault() {
        UserDefaults.standard.removeObject(forKey: "LastLogin")
        UserDefaults.standard.removeObject(forKey: "LOGIN")
        UserDefaults.standard.removeObject(forKey: "json")
        UserDefaults.standard.removeObject(forKey: "image")
        UserDefaults.standard.removeObject(forKey: "first_name")
        UserDefaults.standard.removeObject(forKey: "last_name")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "mobile")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "activation_code")
        UserDefaults.standard.removeObject(forKey: "client_credit")
        UserDefaults.standard.removeObject(forKey: "active")
        UserDefaults.standard.removeObject(forKey: "country_code")
        UserDefaults.standard.removeObject(forKey: "country_id")
        UserDefaults.standard.removeObject(forKey: "payment_method")
        UserDefaults.standard.removeObject(forKey: "payment_method_text")
    }
    
}



class User : Decodable{
    
    var activation_code : Int?
    var active : String?
//    var block : String?a
    var client_credit : Int?
    var country_code : String?
    var country_id : Int?
    var currency : String?
    var email : String?
    var first_name : String?
    var image : String?
    var last_name : String?
    var mobile : String?
    var payment_method : String?
    var payment_method_text : String?
    var places : [PlacesResult]?
    var driver : Driver?

    
    public static func convertToModel(response: Data?) -> User{
        do{
            let data = try JSONDecoder().decode(self, from: response!)
            return data
        }catch{
            return User()
        }
    }
    
    
}


