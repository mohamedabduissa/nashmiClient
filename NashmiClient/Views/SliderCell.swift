//
//  SliderCell.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/14/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell, CellProtocol {

    @IBOutlet weak var sliderImage: UIImageView!

    func setup() {
     
        guard let url = model as? String else { return }
        sliderImage.setImage(url: url)
    }
}
