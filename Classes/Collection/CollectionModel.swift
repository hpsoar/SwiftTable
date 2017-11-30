//
//  CollectionModel.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

public protocol CollectionModelDelegate: NSObjectProtocol {
    func collectionModel(_ collectionModel: CollectionModel, cellForCollectionView collectionView: UICollectionView, indexPath: IndexPath, object: AnyObject) -> UICollectionViewCell?
}

public class CollectionModel: TypedModel {
    weak var delegate: CollectionModelDelegate!
    
    public init(sections: [CellObjectModel.Section], delegate: CollectionModelDelegate) {
        self.delegate = delegate
        super.init(sections: sections)
    }
    
    public convenience init(list: [AnyObject], delegate: CollectionModelDelegate) {
        self.init(sections: [(nil, objects: list)], delegate: delegate)
    }
    
    public convenience init(delegate: CollectionModelDelegate) {
        self.init(sections: [(nil, objects: [])], delegate: delegate)
    }
}

extension CollectionModel: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.typedModel().sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.typedModel().sections[section].objects.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object: AnyObject = self.typedModel().objectAtPath(indexPath)
        
        return self.delegate.collectionModel(self, cellForCollectionView: collectionView, indexPath: indexPath, object: object)!
    }
    
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//    }
}
