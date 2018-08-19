//
//  PaymentMethodCell.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/10/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell , CellProtocol {

    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var methodName: UILabel!
    @IBOutlet weak var methodImage: UIImageView!
    
    var checked:Bool = false
    func setup() {
        guard let data = self.model as? PaymentMethodModel else { return }
        if checked {
            successImage.isHidden = false
        }else{
            successImage.isHidden = true
        }
        methodName.text = data.name
        methodImage.image = data.image
    }
    
}
