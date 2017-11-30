//
//  CollectionVC.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {

    var collectionView: UICollectionView!
    
    // Model
    var collectionModel: CollectionModel? {
        didSet {
            collectionView.dataSource = collectionModel
        }
    }
    
    // delegate
    
    // TODO: refresh ui interface
    
    // TODO: data loader interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds)
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}
