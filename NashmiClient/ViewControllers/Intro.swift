//
//  Intro.swift
//  NashmiClient
//
//  Created by mohamed abdo on 8/9/18.
//  Copyright © 2018 Nashmi. All rights reserved.
//

import Foundation

class Intro:BaseController {
    @IBOutlet weak var sliderCollection: UICollectionView!
    
    @IBOutlet weak var aboutNashmi: UILabel!
    
    var sliders:[String] = []
    override func viewDidLoad() {
        super.hiddenNav = true
        super.viewDidLoad()
        if UserRoot.isLogin() {
            let vc = self.pushViewController(Home.self)
            self.push(vc,false)
        }
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
        aboutNashmi.text = BaseController.config?.config?.intro
        if let slider = BaseController.config?.sliders {
            self.sliders.append(contentsOf: slider)
        }
        sliderCollection.delegate = self
        sliderCollection.dataSource = self
        sliderCollection.reloadData()
    }
    override func bind() {
        
    }
    override func notifySetting() {
        aboutNashmi.text = BaseController.config?.config?.intro
        if let slider = BaseController.config?.sliders {
            self.sliders.append(contentsOf: slider)
        }
        sliderCollection.delegate = self
        sliderCollection.dataSource = self
        sliderCollection.reloadData()
    }
    @IBAction func register(_ sender: Any) {
        let vc = pushViewController(Register.self)
        push(vc)
    }
    @IBAction func login(_ sender: Any) {
        let vc = pushViewController(Login.self)
        push(vc)
    }
}

extension Intro :UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard var cell = collectionView.cell(type: SliderCell.self, indexPath) else { return UICollectionViewCell() }
        cell.model = self.sliders[indexPath.item]
        return cell
    }
    
    
}
