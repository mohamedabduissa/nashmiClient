//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

protocol BookingSuccessDelegate:class {
    func apply()
}

class BookingSuccessPOP:BaseController {
    @IBOutlet weak var successMessage: UILabel!
    
    var estimateTime:String?
    weak var delegate:BookingSuccessDelegate?
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
      
    }
    
    func setup() {
        let word = translate("your_booking_has_been_confirmed_driver_will_pick_up_you_in_")
        successMessage.text = "\(word) \(estimateTime ?? "")"
    }
    override func bind() {
        
    }
    @IBAction func apply(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.apply()
        })
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
