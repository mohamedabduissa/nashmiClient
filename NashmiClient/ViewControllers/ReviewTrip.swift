//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import Cosmos

class ReviewTrip:BaseController {
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var orginLocation: UILabel!
    @IBOutlet weak var tripPrice: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var comment: FloatLabelTextField!
    
    var trip:TripResult?
    var viewModel:TripViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setup()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
    }
    
    func setup() {
        viewModel = TripViewModel()
        rate.rating = 0
        destinationLocation.text = trip?.to_location
        orginLocation.text = trip?.from_location
        tripPrice.text = trip?.total_price?.string
    }
    override func bind() {
        viewModel?.message.bind({ (message) in
        })
    }
    
    override func backBtn(_ sender: Any) {
        BaseController.currentTrip = nil
        let vc = pushViewController(Home.self)
        push(vc,false)
    }
    @IBAction func help(_ sender: Any) {
    }
    
    @IBAction func rateNow(_ sender: Any) {
        if rate.rating != 0 {
            guard let id = self.trip?.id else { return }
            self.viewModel?.rate(trip:id,rate: rate.rating.int, comment: comment.text)
            self.backBtn(self)

        }
    }
}
