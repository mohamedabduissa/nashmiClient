//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class ConfirmRequest:BaseController {
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var orginLocation: UILabel!
    
    var orgin:String?
    var destination:String?
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
        orginLocation.text = orgin
        destinationLocation.text = destination
    }
    override func bind() {
        viewModel?.cancelMessage.bind({ (data) in
            self.SnackBar(message: data, dismissClosure: {
                let vc = self.pushViewController(Home.self)
                self.push(vc)
            })
            
        })
    }
    
    @IBAction func cancelRequest(_ sender: Any) {
        let vc = pushViewController(BookingCancelPOP.self)
        vc.delegate = self
        pushPop(vc: vc)
    }
    
}

extension ConfirmRequest:BookingCancelDelegate, CancelReasonDelegate {
    func apply() {
        let vc = pushViewController(CancelationReasonPOP.self)
        vc.delegate = self
        pushPop(vc: vc)
    }
    func reason(reason: Int) {
        viewModel?.cancel(reason: reason)
        
    }
}
