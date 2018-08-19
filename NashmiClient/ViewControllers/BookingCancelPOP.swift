//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

protocol BookingCancelDelegate:class {
    func apply()
}
class BookingCancelPOP:BaseController {
    
    weak var delegate:BookingCancelDelegate?
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
        
    }
    override func bind() {
        
    }
    @IBAction func apply(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.apply()
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
