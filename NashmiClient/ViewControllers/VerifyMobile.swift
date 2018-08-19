//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class VerifyMobile:BaseController {
    @IBOutlet weak var otpPassword: FloatLabelTextField!
    @IBOutlet weak var message: UILabel!
    
    var viewModel:UserViewModel?
    var mobile:String!
    var code:Int!
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
        self.SnackBar(message: code.string)
        
        viewModel = UserViewModel()
        viewModel?.delegate = self
        message.text = translate("we're_unable_to_auto_verify_your_mobile_number_._please_enter_the_code_tested_to_")
        message.text = message.text!+" \(mobile ?? "")"
        
    }
    override func bind() {
        viewModel?.message.bind({ (message) in
            let vc = self.pushViewController(SelectPaymentMethod.self)
            self.push(vc)
        })
    }
    override func validation() -> Bool {
        return true
    }
    @IBAction func submit(_ sender: Any) {
        if self.validation() {
            viewModel?.activate(code: code)
        }
    }
}
