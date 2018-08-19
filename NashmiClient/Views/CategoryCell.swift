//
//  CategoryCell.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/14/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell,CellProtocol {

    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
   
    var checked:Bool = false
    func setup() {
        guard let data = model as? ConfigCategory else { return subCategorySetup() }
        if checked {
            successImage.isHidden = false
        }else{
            successImage.isHidden = true
        }
        categoryName.text = data.name
        categoryDescription.text = data.description
        categoryImage.setImage(url: data.img)
    }
    func subCategorySetup() {
        guard let data = model as? SubCategoryResult else { return }
        if checked {
            successImage.isHidden = false
        }else{
            successImage.isHidden = true
        }
        categoryName.text = data.name
        categoryDescription.text = data.description
        categoryImage.setImage(url: data.image)
    }
    
}
