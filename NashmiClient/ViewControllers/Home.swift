//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import GoogleMaps
class Home:BaseController {
    
    @IBOutlet weak var sendRequestBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!

    var mapHelper:GoogleMapHelper?
    var viewModel:TripViewModel?
    var lat:Double?
    var lng:Double?
    var drivers:[TripDriver] = []
    var oldDrivers:[TripDriver] = []
    var trip:TripResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTrip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = TripViewModel()
        bind()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
        drivers.removeAll()
    }
    
    func goToPickUp(){
        
        if self.trip?.id != nil || BaseController.currentTrip?.id != nil {
            let vc = pushViewController(PickupMap.self)
            vc.trip = self.trip
            if BaseController.currentTrip != nil && self.trip?.id == BaseController.currentTrip?.id {
                vc.trip = BaseController.currentTrip
            }
            push(vc,false)
        }
    }
    func setup() {

        mapHelper = GoogleMapHelper()
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapHelper?.mapView = mapView
        mapHelper?.delegate = self
        mapHelper?.currentLocation()
        mapHelper?.markerDataSource = self
        
        sendRequestBtn.isHidden = true
        
    }
    func setupTrip(){
        let _ = TimeHelper(seconds: 8, closure: updateMap)
        
    }
    func updateMap(counter:Int){
        if self.lat != nil && self.lng != nil {
            viewModel?.current(lat!, lng!)
        }
    }
    override func bind() {
        viewModel?.drivers.bind({ (drivers) in
            if self.oldDrivers.count == 0 {
                self.oldDrivers.append(contentsOf: drivers)
            }else{
                self.oldDrivers.removeAll()
                self.oldDrivers.append(contentsOf: self.drivers)
            }
            self.drivers.removeAll()
            self.drivers.append(contentsOf: drivers)
            
            self.mapHelper?.refreshARMovement(lat: self.lat, lng: self.lng)
        })
        
        viewModel?.currentTrip.bind({ (current) in
            self.trip = current
            BaseController.currentTrip = current
            if self.trip?.id != nil {
                self.goToPickUp()
                self.sendRequestBtn.isHidden = true
            }else{
                self.sendRequestBtn.isHidden = false
            }
        })
    }
    @IBAction func sendRequest(_ sender: Any) {
        let vc = pushViewController(Categories.self)
        push(vc)
        
    }
}

extension Home:GoogleMapHelperDelegate {
    func locationCallback(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        self.updateMap(counter: 0)
    }
}

extension Home:MarkerDataSource {
    func checkInOldDrivers(_ driver:TripDriver)->Int? {
        let indexes = oldDrivers.indices(of: driver)
        return indexes.first
    }
    func marker() -> MarkerAttrbuite {
        var attr = MarkerAttrbuite()
        attr.use = .icon
        attr.icon = #imageLiteral(resourceName: "pinColored")
        return attr
    }
    func setMarkers() -> [GMSMarker] {
        var markers:[GMSMarker] = []
        drivers.forEach { (data) in
            let marker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "carColored")
            if let old = checkInOldDrivers(data)  {
                guard let lat = oldDrivers[old].lat?.double() ,  let lng = oldDrivers[old].lng?.double() else { return }
                marker.oldPosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }else{
                guard let lat = data.lat?.double() ,  let lng = data.lng?.double() else { return }
                marker.oldPosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            guard let lat = data.lat?.double() ,  let lng = data.lng?.double() else { return }
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            markers.append(marker)
        }
        return markers
    }
    
}
