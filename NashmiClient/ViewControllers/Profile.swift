//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class Profile:BaseController {
    
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var containerCountryView: UIView!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var password: FloatLabelTextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: FloatLabelTextField!
    @IBOutlet weak var lastName: FloatLabelTextField!
    @IBOutlet weak var firstName: FloatLabelTextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var placesCollection: UITableView!
    @IBOutlet weak var placesHeight: NSLayoutConstraint!
    
    var places:[PlacesResult] = []
    var countries:[ConfigCountry] = []
    var countrySelected:Int = 0
    var viewModel:UserViewModel?
    var placeViewModel:PlacesViewModel?
    var imagePicker:ImagePickerHelper?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = UserViewModel()
        self.viewModel?.delegate = self
        self.placeViewModel = PlacesViewModel()
        setup()
        setupProfile()
        setupPlaces()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        places.removeAll()
        self.viewModel = nil
        self.placeViewModel = nil
    }
    
    func setup() {
        
        
        self.placesHeight.constant = 0
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
    func setupProfile(){
        let user = UserRoot.getUserFromCache()
        userImage.setImage(url: user.result?.image)
        firstName.text = user.result?.first_name
        lastName.text = user.result?.last_name
        email.text = user.result?.email
        mobile.text = user.result?.mobile
    }
    func setupPlaces(){
        placesCollection.delegate = self
        placesCollection.dataSource = self
        placesCollection.reloadData()
        
        let user = UserRoot.getUserFromCache()
        guard let list = user.result?.places else { return }
        placesHeight.constant = list.count.cgFloat*85
        places.append(contentsOf: list)
        self.placesCollection.reloadData{
            self.placesCollection.animateZoom(0.20)
        }
       
        
    }
    override func bind() {
        viewModel?.model.bind({ (data) in
            self.viewModel?.delegate = self
            self.setupProfile()
        })
        
        placeViewModel?.message.bind({ (message) in
        })
    }
    
    override func validation() -> Bool {
        let validate = Validation(textFields: [firstName , lastName , email , mobile])
        return validate.success
    }
    
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
    
    @IBAction func addPlace(_ sender: Any) {
        let vc = pushViewController(SetPlace.self)
        push(vc)
    }
    
    @IBAction func changeImage(_ sender: Any) {
        imagePicker = ImagePickerHelper(self)
    }
    @IBAction func edit(_ sender: Any) {
        makeAlert(translate(translate("edit_profile"))) {
            if self.validation(){
                if !self.countries.isset(self.countrySelected){
                    self.SnackBar(message: translate("please_select_country"))
                    return
                }
                var paramters:[String:String] = [:]
                paramters["first_name"] = self.firstName.text
                paramters["last_name"] = self.lastName.text
                paramters["email"] = self.email.text
                paramters["mobile"] = self.mobile.text
                paramters["country_id"] = self.countries[self.countrySelected].id?.string
                
                if self.password.text != nil && self.password.text!.count > 1 {
                    paramters["password"] = self.password.text
                }
                self.viewModel?.update(paramters: paramters)
            }
        }
    
    }
}

extension Profile:UIPickerViewDelegate , UIPickerViewDataSource {
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
extension Profile:ImagePickerDelegate {
    func pickerCallback(image: UIImage) {
        self.userImage.image = image
        let paramters:[String:String] = ["image":image.base64(format: .JPEG(0.075))]
        viewModel?.update(paramters: paramters)
    }
}


extension Profile:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: PlaceCell.self, indexPath) else { return UITableViewCell() }
        cell.delegate = self
        cell.model = places[indexPath.row]
        return cell
    }
    
    
}

extension Profile:PlaceCellDelegate {
    func edit(path: Int?) {
        guard let index = path else { return }
        if places.isset(index){
            let vc = pushViewController(SetPlace.self)
            vc.placeId = places[index].id
            vc.place = places[index]
            push(vc)
        }
        
    }
    
    func delete(path: Int?) {
        guard let index = path else { return }
        if places.isset(index){
            self.placeViewModel?.delete(place: places[index].id!)
            self.viewModel?.delegate = nil
            self.viewModel?.update(paramters: [:])
            self.places.remove(at: index)
            placesHeight.constant = self.places.count.cgFloat*85
            self.placesCollection.reloadData()
        }
    }
}

