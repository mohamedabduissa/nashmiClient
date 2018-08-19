//
//  SubCategoryCell.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/14/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import UIKit

class CancelReasonCell: UITableViewCell,CellProtocol {

    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var reasonName: UILabel!
 
    var checked:Bool = false
    func setup() {
        guard let data = model as? ConfigCancelReason else { return }
        if checked {
            successImage.isHidden = false
        }else{
            successImage.isHidden = true
        }
        reasonName.text = data.name
    }
}
