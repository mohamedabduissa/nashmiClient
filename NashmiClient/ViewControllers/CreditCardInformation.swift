//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation
import MFCard

protocol CreditCardDelegate:class {
    func card(holder:String , cardNumber:String , month:String , year :String , cvc:String)
}
class CreditCardInformation:BaseController {
    @IBOutlet weak var cardView: MFCardView!
    
    weak var delegate:CreditCardDelegate?
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
        cardView.btnDone.isHidden = true
        
        
    }
    override func bind() {
        
    }
    @IBAction func next(_ sender: Any) {
        guard let holder = cardView.txtCardName.text else { return }
        let number = cardView.txtCardNoP1.text! + cardView.txtCardNoP2.text! + cardView.txtCardNoP3.text! + cardView.txtCardNoP4.text!
        guard let month = getMonth() else { return }
        guard let year = getYear() else{ return }
        guard let cvc = cardView.txtCvc.text else { return }
        self.navigationController?.popViewController({
            self.delegate?.card(holder: holder, cardNumber: number, month: month, year: year, cvc: cvc)
        })
    }
    public func getMonth()->String?{
        return Month(rawValue: cardView.viewExpiryMonth!.labelValue.text!)?.rawValue
    }
    public func getYear()->String?{
        return cardView.viewExpiryYear!.labelValue.text!
    }
    
}


