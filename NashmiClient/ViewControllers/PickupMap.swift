//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import GoogleMaps
import Cosmos
import Lottie
class PickupMap:BaseController {
    enum LocationSelection {
        case current
        case driver
        case change
    }
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var driverInfoView: UIView!
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var orginLocation: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverRate: CosmosView!
    @IBOutlet weak var rateNumber: UILabel!
    @IBOutlet weak var driverCar: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var driverLocation: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    /** location selection */
    var locationSelection:LocationSelection = .current
    
    var trip:TripResult?
    var viewModel:TripViewModel?
    var mapHelper:GoogleMapHelper?
    var lat:Double?
    var lng:Double?
    var driverMarker:GMSMarker = GMSMarker()
    /** search attrs */
    lazy var parentView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        return view
    }()
    let animationView:LOTAnimationView = LOTAnimationView(name: "searchLoti")
    
    /** */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkTrip()
        setup()
        setupMap()
        setupTrip()
        refresh()
        viewModel = TripViewModel()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkTrip()
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    func checkTrip(){
        if let _ = trip{
            
        }else if let _ = BaseController.currentTrip {
            self.trip = BaseController.currentTrip
        }else{
            let vc = pushViewController(Home.self)
            push(vc)
        }
    }
    
    func setup() {
        orginLocation.text = trip?.from_location
        destinationLocation.text = trip?.to_location
    
        driverImage.setImage(url: trip?.driver?.image)
        driverName.text = "\(trip?.driver?.first_name ?? "") \(trip?.driver?.last_name ?? "")"
        if let rating = trip?.driver?.driver?.rate?.double() {
            driverRate.rating  = rating
            rateNumber.text = rating.string
        }
        if let car = trip?.driver?.driver?.car {
            driverCar.text = "\(car.brand_name ?? "") \(car.model_name ?? "") \(car.color_name ?? "")"
        }
        status.text = trip?.status_text
        driverLocation.text = ""
        paymentMethod.text = trip?.payment_method_text

    }
    func setupMap(){
        locationSelection = .current
        mapHelper = GoogleMapHelper()
        mapHelper?.mapView = self.mapView
        mapHelper?.delegate = self
        mapHelper?.markerDataSource = self
        mapHelper?.polylineDataSource = self
        mapHelper?.currentLocation()
    }
    func setupTrip(){
        let _ = TimeHelper(seconds: 8, closure: updateMap)
        
    }
    func updateMap(counter:Int){
        if self.lat != nil && self.lng != nil {
            viewModel?.delegate = nil
            viewModel?.current(lat!, lng!)
        }
    }
    func refresh(){
        guard let status = self.trip?.status else { return }
        if status  == TripViewModel.TripStatus.opened.rawValue {
            showSearch()
        }else if status == TripViewModel.TripStatus.accepted.rawValue {
            drawRoadToDriver()
        }else if status == TripViewModel.TripStatus.arrived.rawValue {
            
        }else if status == TripViewModel.TripStatus.started.rawValue {
            self.mapView.clear()
            drawRoadToDestination()
        }else if status == TripViewModel.TripStatus.completed.rawValue {
            
        }else if status == TripViewModel.TripStatus.collected.rawValue {
            let vc = pushViewController(ReviewTrip.self)
            vc.trip = self.trip
            push(vc)
            viewModel = nil
        }
        self.setup()
    }
 
    override func bind() {
        viewModel?.currentTrip.bind({ (data) in
            if data.id != nil {
                self.trip = data
                BaseController.currentTrip = data
            }else{
                self.trip?.status = 7
            }
            
            self.refresh()
        })
        
        viewModel?.cancelMessage.bind({ (data) in
            self.viewModel = nil
            let vc = self.pushViewController(Home.self)
            self.push(vc)
        })
        
    }
    
    @IBAction func orginSearch(_ sender: Any) {
        //        self.selection = .orgin
        //        self.mapHelper?.search()
    }
    @IBAction func destinationSearch(_ sender: Any) {
        makeAlert(translate("are_you_sure_to_chage_destination")) {
            self.locationSelection = .change
            self.mapHelper?.search()
        }
      
    }
    @IBAction func calling(_ sender: Any) {
        let mobile = self.trip?.driver?.mobile
        call(text: mobile)
    }
    @IBAction func cancelBooking(_ sender: Any) {
        makeAlert(translate("are_you_sure")) {
            let vc = self.pushViewController(BookingCancelPOP.self)
            vc.delegate = self
            self.pushPop(vc: vc)
        }
    }
    @IBAction func sos(_ sender: Any) {
    }
}

/** opened trip functions */
extension PickupMap{
    func showSearch() {
        if self.parentView.superview == self.view {
            return
        }
        self.driverInfoView.isHidden = true

        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let animationView:LOTAnimationView = LOTAnimationView(name: "searchLoti")
        // Setup our animaiton view
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: (parentView.width/2)-50, y: (parentView.height/2)-100, width: 100, height: 100)
        // Lets turn looping on, since we want it to repeat while the image is 'Downloading'
        animationView.loopAnimation = true
        // Now play from 0 to 0.5 progress and loop indefinitely.
        animationView.play(fromProgress: 0, toProgress: 1, withCompletion: nil)
        
        
        /** cancel Button */
        let button = UIButton(frame: CGRect(x: 15, y: parentView.height-175, width: parentView.width-30, height: self.cancelBtn.height))
        button.backgroundColor = self.cancelBtn.backgroundColor
        button.setTitleColor(self.cancelBtn.titleColor(for: .normal), for: .normal)
        button.cornerRadius = self.cancelBtn.cornerRadius
        button.setTitle(self.cancelBtn.title(for: .normal), for: .normal)
        button.addTarget(self, action: #selector(self.cancelBooking(_:)), for: .touchUpInside)
       
        parentView.addSubview(button)
        parentView.addSubview(animationView)
        self.view.addSubview(parentView)
        
    }
   
}

/** accepted trip functions */
extension PickupMap{
    func stopSearch(){
        self.animationView.loopAnimation = false
        self.animationView.removeFromSuperview()
        self.parentView.removeFromSuperview()
        if self.driverInfoView.isHidden  {
            self.driverInfoView.animateZoom(0.10) {
                self.driverInfoView.isHidden = false
            }
        }
        
    }
    func setDriverMarker(){
        guard let lat = trip?.driver?.driver?.lat?.double() , let lng = trip?.driver?.driver?.lng?.double() else { return }

        driverMarker.icon = #imageLiteral(resourceName: "carColored")
        driverMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.mapHelper?.setMarker(marker: driverMarker)
    }
    func setDriverAddress(){
        guard let lat = trip?.driver?.driver?.lat?.double() , let lng = trip?.driver?.driver?.lng?.double() else { return }
        self.locationSelection = .driver
        self.mapHelper?.address(lat: lat , lng: lng)

    }
    func drawRoadToDriver(){
        if self.lat == nil && self.lng == nil {
            return
        }
        self.stopSearch()
        self.setDriverMarker()
        self.setDriverAddress()
        guard let lat = trip?.driver?.driver?.lat?.double() , let lng = trip?.driver?.driver?.lng?.double() else { return }
        
        let orgin = CLLocation(latitude: self.lat!, longitude: self.lng!)
        let destination = CLLocation(latitude: lat, longitude: lng)
        self.mapHelper?.drawRoute(orgin: orgin, destination: destination)
    }
}

/** arrived trip functions */
extension PickupMap{
    func drawRoadToDestination(){
        if self.lat == nil && self.lng == nil {
            return
        }
        guard let lat = trip?.driver?.driver?.lat?.double() , let lng = trip?.driver?.driver?.lng?.double() else { return }
        guard let destinationLat = trip?.to_lat , let destinationLng = trip?.to_lng else { return }
        
        self.stopSearch()
        self.setDriverAddress()
        self.mapHelper?.updateCameraWithOutMarker(lat: lat, lng: lng)

        self.setDriverMarker()
       
        let orgin = CLLocation(latitude: lat, longitude: lng)
        let destination = CLLocation(latitude: destinationLat, longitude: destinationLng)
        self.mapHelper?.drawRoute(orgin: orgin, destination: destination)
        
    }
}


extension PickupMap: GoogleMapHelperDelegate {
    func locationCallback(lat: Double, lng: Double) {
        if locationSelection == .current {
            self.lat = lat
            self.lng = lng
            self.refresh()
        }else if locationSelection == .change {
            self.viewModel?.changeDestination(lat: lat, lng: lng)
        }
    }
    func locationCallback(address: String?) {
        if locationSelection == .driver {
            self.driverLocation.text = address
        }
    }
}
extension PickupMap:MarkerDataSource , PolylineDataSource {
    func marker() -> MarkerAttrbuite {
        var attr = MarkerAttrbuite()
        attr.use = .icon
        attr.icon = #imageLiteral(resourceName: "pinColored")
        return attr
    }
    func polyline() -> PolylineAttrbuite {
        var attr = PolylineAttrbuite()
        attr.color = .blue
        attr.width = 2
        return attr
    }
}


extension PickupMap:BookingCancelDelegate, CancelReasonDelegate{
    func apply() {
        let vc = pushViewController(CancelationReasonPOP.self)
        vc.delegate = self
        pushPop(vc: vc)
    }
    func reason(reason: Int) {
        self.viewModel?.delegate = self
        self.viewModel?.cancel(reason: reason)
    }
}

