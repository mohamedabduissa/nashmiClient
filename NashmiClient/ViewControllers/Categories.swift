//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class Categories:BaseController {
    @IBOutlet weak var categoriesCollection: UITableView!
    
    var categories:[ConfigCategory] = []
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
        self.categories.removeAll()
    }
    
    func setup() {
        self.firstShow()
    }
    override func notifySetting() {
        self.firstShow()
    }
    func fromSelfDetail(){
        
    }
    func firstShow(){
        if let list = BaseController.config?.categories {
            self.categories.append(contentsOf: list)
            self.categoriesCollection.delegate = self
            self.categoriesCollection.dataSource = self
            self.categoriesCollection.animate {
                self.categoriesCollection.reloadData()
            }
        }
    }
    override func bind() {
        
    }
    @IBAction func next(_ sender: Any) {
        if categories.isset(categorySelected){
            let category = categories[categorySelected]
            if category.has_sub != nil && category.has_sub! == true {
                let vc = pushViewController(SubCategories.self)
                vc.category = category
                push(vc)
            }else{
                let vc = pushViewController(SendRequest.self)
                vc.category = category.id!
                push(vc)
            }
            
        }
    }
}

extension Categories:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: CategoryCell.self, indexPath) else { return UITableViewCell() }
        if categorySelected == indexPath.row {
            cell.checked = true
        }else{
            cell.checked = false
        }
        cell.model = self.categories[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categorySelected = indexPath.row
        tableView.reloadData()
    }
    
}
