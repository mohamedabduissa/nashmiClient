//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

protocol CancelReasonDelegate:class {
    func reason(reason:Int)
}
class CancelationReasonPOP:BaseController {
    @IBOutlet weak var reasonsCollection: UITableView!
    
    var reasons:[ConfigCancelReason] = []
    var reasonSelected:Int = 0
    weak var delegate:CancelReasonDelegate?
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
        guard let list = BaseController.config?.cancel_reasons else { return }
        reasons.append(contentsOf: list)
        reasonsCollection.delegate = self
        reasonsCollection.dataSource = self
        reasonsCollection.reloadData()
    }
    override func bind() {
        
    }
    @IBAction func apply(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.reasons.isset(self.reasonSelected) {
                guard let id = self.reasons[self.reasonSelected].id else { return }
                self.delegate?.reason(reason: id)
            }
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CancelationReasonPOP:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.cell(type: CancelReasonCell.self, indexPath) else { return UITableViewCell() }
        if  reasonSelected == indexPath.row  {
            cell.checked = true
        }else{
            cell.checked = false
        }
        cell.model = reasons[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reasonSelected = indexPath.row
        tableView.reloadData()
    }
    
    
    
}
