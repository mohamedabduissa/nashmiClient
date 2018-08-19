//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class SubCategories:BaseController {
    
    
    @IBOutlet weak var categoriesCollection: UITableView!
   
    
    var category:ConfigCategory!
    var categories:[SubCategoryResult] = []
    var viewModel:CategoryViewModel?
    var categorySelected:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    func setup() {
        viewModel = CategoryViewModel()
        self.categoriesCollection.delegate = self
        self.categoriesCollection.dataSource = self
        guard let id = category.id else { return }
        viewModel?.fetchData(id)
    }
    override func bind() {
        viewModel?.model.bind({ (data) in
            self.categories.append(contentsOf: data)
            self.categoriesCollection.animate(closure: {
                self.categoriesCollection.reloadData()
            })
        })
    }
    @IBAction func next(_ sender: Any) {
        if categories.isset(categorySelected){
            let category = categories[categorySelected]
            let vc = pushViewController(SubCategoriesChilds.self)
            vc.categoryParentID = self.category.id
            vc.category = category
            if category.childs != nil {
                vc.categories = category.childs!
            }
            push(vc)
        }
    }
}

extension SubCategories:UITableViewDelegate , UITableViewDataSource {
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
        cell.model = categories[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categorySelected = indexPath.row
        tableView.reloadData()
    }
    
}
