//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class SelectPaymentMethod:BaseController {
    @IBOutlet weak var paymentCollection: UITableView!
    
    var methods:[PaymentMethodModel] = []
    var methodSelected:Int = 0
    var viewModel:UserViewModel?
    
    var holderName:String?
    var cardNumber:String?
    var year:String?
    var month:String?
    var cvc:String?
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
        viewModel =  nil
        methods.removeAll()
    }
    
    func setup() {
        viewModel = UserViewModel()
        viewModel?.delegate = self
        self.setupMethods()
        self.paymentCollection.delegate = self
        self.paymentCollection.dataSource = self
        self.paymentCollection.reloadData()
    }
    func setupMethods(){
        let method1 = PaymentMethodModel(id: 1, image: #imageLiteral(resourceName: "paypal"), name: translate("paypal"),index:.paypal)
        let method2 = PaymentMethodModel(id: 2, image: #imageLiteral(resourceName: "credit"), name: translate("credit/debit"),index:.credit)
        let method3 = PaymentMethodModel(id: 3, image: #imageLiteral(resourceName: "cash"), name: translate("cash"),index:.cash)
        methods.append(method1)
        methods.append(method2)
        methods.append(method3)
        
        if UserRoot.instance.result?.payment_method_text == "cash"{
            methodSelected = 2
        }else if UserRoot.instance.result?.payment_method_text == "paypal" {
            methodSelected = 0
        }else{
            methodSelected = 1
        }
    }
    override func bind() {
        viewModel?.model.bind({ (data) in
            MenuVC.currentIndex = .home
            let vc = self.pushViewController(Home.self)
            self.push(vc)
        })
    }
    @IBAction func done(_ sender: Any) {
        if methodSelected == 1 && holderName == nil {
            let vc = pushViewController(CreditCardInformation.self)
            vc.delegate = self
            push(vc)
        }else if methodSelected == 1 && holderName != nil {
            var paramters:[String:String] = [:]
            paramters["payment_method"] = methods[methodSelected].index?.rawValue
            paramters["full_name"] = holderName
            paramters["card_number"] = cardNumber
            paramters["expire"] = "\(month ?? "01")/\(year ?? "2000")"
            paramters["cvv"] = cvc
            viewModel?.update(paramters: paramters)
        }else{
            var paramters:[String:String] = [:]
            paramters["payment_method"] = methods[methodSelected].index?.rawValue
            viewModel?.update(paramters: paramters)
        }
    }
}

extension SelectPaymentMethod:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: PaymentMethodCell.self, indexPath) else { return UITableViewCell() }
        if methodSelected == indexPath.row {
            cell.checked = true
        }else{
            cell.checked = false
        }
        cell.model = methods[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        methodSelected = indexPath.row
        self.paymentCollection.reloadData()
    }
    
    
}

extension SelectPaymentMethod:CreditCardDelegate {
    func card(holder: String, cardNumber: String, month: String, year: String, cvc: String) {
        self.holderName = holder
        self.cardNumber = cardNumber
        self.month = month
        self.year = year
        self.cvc = cvc
    }

}
