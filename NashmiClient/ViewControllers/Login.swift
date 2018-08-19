//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class Login:BaseController {
    @IBOutlet weak var username: FloatLabelTextField!
    @IBOutlet weak var password: FloatLabelTextField!
    
    var viewModel:UserViewModel?
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
        viewModel = UserViewModel()
        viewModel?.delegate = self
    }
    override func bind() {
        viewModel?.model.bind({ (data) in
            let vc = self.pushViewController(Home.self)
            self.push(vc)
        })
    }
    override func validation() -> Bool {
        let validate = Validation(textFields: [username,password])
        return validate.success
    }
   
}

extension Login {
    @IBAction func google(_ sender: Any) {
    }
    @IBAction func facebook(_ sender: Any) {
    }
    
    @IBAction func forget(_ sender: Any) {
        let vc = pushViewController(ForgetPassword.self)
        push(vc)
    }
    @IBAction func login(_ sender: Any) {
        if self.validation() {
            viewModel?.login(username: username.text!, password: password.text!)
        }
    }
}
