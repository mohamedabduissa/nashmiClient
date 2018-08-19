//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class SubCategoriesChilds:BaseController {
    
    
    @IBOutlet weak var categoriesCollection: UITableView!
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var categoryParentID:Int?
    var category:SubCategoryResult!
    var categories:[SubCategoryChild] = []
    var categorySelected:Int = 0

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

        self.categoriesCollection.delegate = self
        self.categoriesCollection.dataSource = self
        self.categoriesCollection.reloadData()
        categoryName.text = category.name
        categoryDescription.text = category.description
        categoryImage.setImage(url: category.image)
    }
    override func bind() {
      
    }
    @IBAction func next(_ sender: Any) {
        if categories.isset(categorySelected) {
            let category = categories[categorySelected]
            let vc = pushViewController(SendRequest.self)
            vc.category = categoryParentID
            vc.subCategory = category.id
            push(vc)
        }
      
    }
}

extension SubCategoriesChilds:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: SubCategoryCell.self, indexPath) else { return UITableViewCell() }
        if categorySelected == indexPath.row {
            cell.checked = true
        }else{
            cell.checked = false
        }
        cell.model = categories[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categorySelected = indexPath.row
        tableView.reloadData()
    }
    
}
