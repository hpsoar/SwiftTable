//
//  BannerLIstView.swift
//  TableDemo
//
//  Created by Huang Peng on 01/12/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class BannerListView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model = CollectionModel(delegate: CollectionCellFactory.collectionModelDelegate())
    
    func updateWithBanners(_ banners: [CollectionCellObject]) {
        model = CollectionModel(list: banners, delegate: CollectionCellFactory.collectionModelDelegate())
        dataSource = model
    }
}
