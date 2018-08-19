//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import GoogleMaps

class SetPlace:BaseController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var orginLocation: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var viewModel:PlacesViewModel?
    var userViewModel:UserViewModel?
    var placeId:Int?
    var place:PlacesResult?
    var mapHelper:GoogleMapHelper?
    var lat:Double?
    var lng:Double?
    var message:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if place != nil {
            self.setupOldPlace()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = PlacesViewModel()
        viewModel?.delegate = self
        userViewModel = UserViewModel()
        userViewModel?.delegate = self
        bind()

    
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
        userViewModel = nil
    }
    
    func setup() {
        
        orginLocation.text = ""
        mapView.settings.myLocationButton = true
        mapHelper = GoogleMapHelper()
        mapHelper?.mapView = mapView
        mapHelper?.changeCameraOnMarker = true
        mapHelper?.delegate = self
        mapHelper?.markerDataSource = self
        if place == nil {
            mapHelper?.currentLocation()
        }
    }
    func setupOldPlace(){
        orginLocation.text = place?.location
        name.text = place?.name
        lat = place?.lat
        lng = place?.lng
        if lat != nil && lng != nil {
            self.mapHelper?.setMarker(position: CLLocationCoordinate2D(latitude: lat!, longitude: lng!))
        }

    }
    override func bind() {
        viewModel?.message.bind({ (message) in
            self.startLoading()
            self.message = message
            self.userViewModel?.update(paramters: [:])
        })
        userViewModel?.model.bind({ (data) in
            self.stopLoading()
            guard let _ = self.message else { return }
            self.SnackBar(message: self.message!,duration: .middle , dismissClosure:{
                self.navigationController?.pop()
            })
        })
    }
    @IBAction func changeLocation(_ sender: Any) {
        mapHelper?.search()
    }
    @IBAction func save(_ sender: Any) {
        guard let lat = self.lat , let lng = self.lng , let name = self.name.text else {
            self.SnackBar(message: translate("please_select_the_location"))
            return
        }
        if self.name.text == nil || self.name.text!.isEmpty {
            self.SnackBar(message: translate("please_select_the_location"))
            return
        }
        if place != nil && placeId != nil {
            viewModel?.update(place:placeId!,lat: lat, lng: lng, name: name)
        }else{
            viewModel?.create(lat: lat, lng: lng, name: name)
        }
    
    }
}

extension SetPlace:GoogleMapHelperDelegate {
    func locationCallback(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        
        self.mapView.clear()
        self.mapHelper?.setMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
    func locationCallback(address: String?) {
        orginLocation.text = address
    }
    func locationCallback(name: String?) {
        self.name.text = name
    }
}

extension SetPlace:MarkerDataSource {
    func marker() -> MarkerAttrbuite {
        var attr = MarkerAttrbuite()
        attr.use = .icon
        attr.icon = #imageLiteral(resourceName: "pinColored")
        return attr
    }
  
}
