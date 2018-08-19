//
//  PlaceCell.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/14/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import UIKit

protocol PlaceCellDelegate:class {
    func edit(path:Int?)
    func delete(path:Int?)
}

class PlaceCell: UITableViewCell , CellProtocol {

    @IBOutlet weak var placeLocation: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
   
    weak var delegate:PlaceCellDelegate?
    
    static var currentImage:Int = 0
    func setup() {
        guard let data = model as? PlacesResult else { return }
        placeLocation.text = data.location
        placeName.text = data.name
        if PlaceCell.currentImage == 0 {
            placeImage.image = #imageLiteral(resourceName: "home")
            PlaceCell.currentImage = 1
        }else{
            placeImage.image = #imageLiteral(resourceName: "work")
            PlaceCell.currentImage = 0
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        let actions:[String:Any] = [translate("edit"):0,translate("delete"):1]
        createActionSheet(title: translate("more"), actions: actions) { (action) in
            if action.keys.first == translate("edit") {
                self.delegate?.edit(path: self.path)
            }else{
                self.delegate?.delete(path: self.path)
            }
        }
    }
    
}
