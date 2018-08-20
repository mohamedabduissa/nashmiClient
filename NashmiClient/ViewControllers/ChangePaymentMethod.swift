//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

protocol ChangePaymentDelegate:class {
    func done(payment:PaymentsMethod)
}
class ChangePaymentMethod:BaseController {
    @IBOutlet weak var fareEstimation: UILabel!
    @IBOutlet weak var paymentCollection: UITableView!
    
    weak var delegate:ChangePaymentDelegate?
    
    var methods:[PaymentMethodModel] = []
    var methodSelected:Int = 0
    var currentMethod:PaymentsMethod?
    var fareEstimate:String?
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
      
    }
    
    func setup() {
        
        self.setupMethods()
        self.paymentCollection.delegate = self
        self.paymentCollection.dataSource = self
        self.paymentCollection.reloadData()
        
        fareEstimation.text = ""
        guard let fare = self.fareEstimate?.int else{
            fareEstimation.text = translate("0", "SAR",true)
            return
        }
        let farePlus = fare+15
        fareEstimation.text = "\(translate(fare.string, "SAR",true)) - \(translate(farePlus.string, "SAR",true))"
        
    }
    func setupMethods(){
        let method1 = PaymentMethodModel(id: 1, image: #imageLiteral(resourceName: "paypal"), name: translate("paypal"),index:.paypal)
        let method2 = PaymentMethodModel(id: 2, image: #imageLiteral(resourceName: "credit"), name: translate("credit/debit"),index:.credit)
        let method3 = PaymentMethodModel(id: 3, image: #imageLiteral(resourceName: "cash"), name: translate("cash"),index:.cash)
        methods.append(method1)
        methods.append(method2)
        methods.append(method3)
        
    }
    override func bind() {
        
    }
    @IBAction func done(_ sender: Any) {
        if self.methods.isset(methodSelected) {
            self.navigationController?.popViewController({
                self.delegate?.done(payment: self.methods[self.methodSelected].index!)
            })
        }
    }
}


extension ChangePaymentMethod:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: PaymentMethodCell.self, indexPath) else { return UITableViewCell() }
        if  currentMethod == methods[indexPath.row].index  {
            methodSelected = indexPath.row
            cell.checked = true
        }else{
            cell.checked = false
        }
        cell.model = methods[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        methodSelected = indexPath.row
        currentMethod = methods[indexPath.row].index
        self.paymentCollection.reloadData()
    }
    
    
}
