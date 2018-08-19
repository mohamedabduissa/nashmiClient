//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class Register:BaseController {
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var containerCountryView: UIView!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var password: FloatLabelTextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: FloatLabelTextField!
    @IBOutlet weak var lastName: FloatLabelTextField!
    @IBOutlet weak var firstName: FloatLabelTextField!
    
    var countries:[ConfigCountry] = []
    var countrySelected:Int = 0
    var viewModel:UserViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setup()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
      viewModel = nil
    }
    
    func setup() {
        self.viewModel = UserViewModel()
        self.viewModel?.delegate = self
        
        countryImage.image = nil
        countryCode.text = "+966"
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        if let _ = BaseController.config?.countries {
            self.countries.append(contentsOf: BaseController.config!.countries!)
            self.countryPicker.reloadAllComponents()
            if countries.isset(countrySelected){
                countryImage.setImage(url: countries[countrySelected].image)
                countryCode.text = countries[countrySelected].code
            }
        }
        
    }
    override func bind() {
        self.viewModel?.model.bind({ (data) in
            let vc = self.pushViewController(VerifyMobile.self)
            let mobile = "\(self.countries[self.countrySelected].code ?? "")\(self.mobile.text ?? "")"
            vc.mobile = mobile
            vc.code = data.result?.activation_code
            self.push(vc)
        })
    }
    
    override func notifySetting() {
        countryImage.image = nil
        countryCode.text = "+966"
        if let _ = BaseController.config?.countries {
            self.countries.append(contentsOf: BaseController.config!.countries!)
            self.countryPicker.reloadAllComponents()
            if countries.isset(countrySelected){
                countryImage.setImage(url: countries[countrySelected].image)
                countryCode.text = countries[countrySelected].code
            }
        }
    }
    override func validation()->Bool {
        let validate = Validation(textFields: [firstName , lastName , email , mobile , password])
        return validate.success
    }
    
}

extension Register{
    @IBAction func agreePicker(_ sender: Any) {
        if countries.isset(countrySelected){
            countryImage.setImage(url: countries[countrySelected].image)
            countryCode.text = countries[countrySelected].code
        }
        self.containerCountryView.isHidden = true
    }
    @IBAction func cancelPicker(_ sender: Any) {
        self.containerCountryView.isHidden = true
    }
    @IBAction func dropDownCountry(_ sender: Any) {
        self.containerCountryView.isHidden = false
        self.countryPicker.reloadAllComponents()
    }
    @IBAction func google(_ sender: Any) {
    }
    @IBAction func facebook(_ sender: Any) {
    }
    @IBAction func next(_ sender: Any) {
        UserRoot.removeCacheingDefault()
        
        if self.validation(){
            if !countries.isset(countrySelected){
                self.SnackBar(message: translate("please_select_country"))
                return
            }
            var paramters:[String:String] = [:]
            paramters["first_name"] = firstName.text
            paramters["last_name"] = lastName.text
            paramters["email"] = email.text
            paramters["mobile"] = mobile.text
            paramters["password"] = password.text
            paramters["country_id"] = countries[countrySelected].id?.string
            
            self.viewModel?.register(paramters: paramters)
        }
    }
}

extension Register:UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countrySelected = row
    }
    
}
