//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

enum CurrentSelection {
    case orgin
    case destination
}
class SendRequest:BaseController {
    
    
    @IBOutlet weak var fareEstimation: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var orginLocation: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    /** class attr */
    var viewModel:TripViewModel?
    var mapHelper:GoogleMapHelper?
    var orgin:CLLocation! = CLLocation()
    var destination:CLLocation! = CLLocation()
    var selection:CurrentSelection = .orgin
    var fareEstimate:String?
    /** */
    
    /** trip post **/
    var category:Int!
    var subCategory:Int?
    var payment:PaymentsMethod!
    var promoCode:String?
    var cancelReason:Int?
    /** */
    
    /** nearest Driver attr */
    var lat:Double?
    var lng:Double?
    var drivers:[TripDriver] = []
    var oldDrivers:[TripDriver] = []
    var trip:TripResult?
    /** */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTrip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* go to pickup map before loaded */
        self.goToPickUp()
        super.viewWillAppear(animated)
        viewModel = TripViewModel()
        bind()

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    func setup() {
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapHelper = GoogleMapHelper()
        mapHelper?.mapView = mapView
        mapHelper?.delegate = self
        mapHelper?.markerDataSource = self
        mapHelper?.polylineDataSource = self
        self.currentLocation()
        orginLocation.text = ""
        destinationLocation.text = translate("drop_down_location")
        self.fareEstimation.text = ""

        guard let method = UserRoot.instance.result?.payment_method_text else { return }
        self.paymentMethod.text = method
        self.payment = PaymentsMethod(rawValue:method)
    }
    func currentLocation(){
        selection = .orgin
        mapHelper?.currentLocation()
    }
    override func bind() {
        self.bindEstimate()
        self.bindDrivers()
        self.bindCreated()
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
    
    @IBAction func orginSearch(_ sender: Any) {
        self.selection = .orgin
        self.mapHelper?.search()
    }
    @IBAction func destinationSearch(_ sender: Any) {
        self.selection = .destination
        self.mapHelper?.search()
    }
    

    
}

/** nearest drivers functions */
extension SendRequest {
    func setupTrip(){
        let _ = TimeHelper(seconds: 8, closure: updateMap)
        
    }
    func updateMap(counter:Int){
        if self.lat != nil && self.lng != nil {
            viewModel?.delegate = nil
            viewModel?.current(lat!, lng!)
        }
    }
    func bindDrivers(){
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
            self.drawPath()
        })
        
    }
}
/** trips functions */
extension SendRequest {
    func drawPath()
    {
        self.mapHelper?.drawRoute(orgin: orgin, destination: destination)
    }
    func estimateTrip(){
        var fromLat = orgin.coordinate.latitude
        var fromLng = orgin.coordinate.longitude
        var toLat = destination.coordinate.latitude
        var toLng = destination.coordinate.longitude
        
        fromLat = Double(fromLat)
        fromLng = Double(fromLng)
        toLat = Double(toLat)
        toLng = Double(toLng)
        self.viewModel?.estimate(from_lat: fromLat, from_lng: fromLng, to_lat: toLat, to_lng: toLng)
    }
    func bindEstimate(){
        viewModel?.estimateTrip.bind({ (trip) in
            self.fareEstimate = trip.fare_estimation
            self.fareEstimation.text = trip.fare_estimation
        })
    }
    @IBAction func confirmRequest(_ sender: Any) {
        if  orgin.coordinate.latitude != 0 && orgin.coordinate.longitude != 0 && category != nil  {
            self.viewModel?.delegate = self
            var paramters:[String:Any] = [:]
            paramters["category_id"] = category
            if subCategory != nil {
                paramters["sub_category_id"] = subCategory
            }
            paramters["payment_method"] = payment.rawValue
            paramters["promo_code"] = promoCode
            paramters["from_lat"] = orgin.coordinate.latitude
            paramters["from_lng"] = orgin.coordinate.longitude
            if destination.coordinate.latitude != 0 && destination.coordinate.longitude != 0 {
                paramters["to_lat"] = destination.coordinate.latitude
                paramters["to_lng"] = destination.coordinate.longitude
            }
            self.viewModel?.create(paramters: paramters)
        }
       
    }
    func bindCreated(){
        viewModel?.created.bind({ (data) in
            self.stopLoading()
            self.viewModel?.delegate = nil
            self.trip = data
            BaseController.currentTrip = data
            let vc = self.pushViewController(BookingSuccessPOP.self)
            vc.delegate = self
            vc.estimateTime = self.trip?.statistics?.arriving_minutes
            self.pushPop(vc: vc)
        })
    }
    
}

extension SendRequest:GoogleMapHelperDelegate{
    func locationCallback(lat: Double, lng: Double) {
        if selection == .orgin {
            self.lat = lat
            self.lng = lng
            self.updateMap(counter: 0)
            orgin = CLLocation(latitude: lat, longitude: lng)
        }else{
            destination = CLLocation(latitude: lat, longitude: lng)
        }
        if destination.coordinate.latitude != 0 {
            drawPath()
            estimateTrip()
        }
    
    }
    func locationCallback(address: String?) {
        if selection == .orgin {
            
            self.orginLocation.text = address
        }else{
            self.destinationLocation.text = address
        }
    }
}

extension SendRequest:PolylineDataSource{
    func polyline() -> PolylineAttrbuite {
        var poly = PolylineAttrbuite()
        poly.width = 2
        poly.color = .blue
        return poly
    }

}
extension SendRequest:MarkerDataSource {
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


/** promoCode **/
extension SendRequest:PromoCodeDelegate{
    @IBAction func promoCode(_ sender: Any) {
        let vc = pushViewController(PromoCodePOP.self)
        vc.delegate = self
        pushPop(vc: vc)
    }
    func agree(code: String?) {
        self.promoCode = code
    }
    
    func cancel() {
        
    }
}

/** payment **/
extension SendRequest:ChangePaymentDelegate {
    @IBAction func changePayment(_ sender: Any) {
        let vc = pushViewController(ChangePaymentMethod.self)
        vc.delegate = self
        vc.fareEstimate = self.fareEstimate
        vc.currentMethod = payment
        push(vc)
    }
    func done(payment: PaymentsMethod) {
        self.payment = payment
        self.paymentMethod.text = self.payment.rawValue
    }
}


/** confirmation */
extension SendRequest:BookingSuccessDelegate {
    func apply() {
        let vc = pushViewController(ConfirmRequest.self)
        vc.orgin = orginLocation.text
        vc.destination = destinationLocation.text
        push(vc)
    }
    func successCancel(){
        let vc = pushViewController(Home.self)
        push(vc)
    }
}
