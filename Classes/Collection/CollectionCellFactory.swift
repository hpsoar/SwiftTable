//
//  CollectionCellFactory.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

/*
 * model to view mapping
 * element -> supplementary
 * object -> cell
 */

// supplementary element
public protocol CollectionSupplementaryElement : NSObjectProtocol {
    func viewClass() -> UICollectionReusableView.Type
}

public protocol CollectionSupplementaryView : NSObjectProtocol {
    func updateWithObject(_ object: CollectionSupplementaryElement)
    
    static func reuseIdentifier() -> String
}

// cell object
public protocol CollectionCellObject: NSObjectProtocol {
    func cellClass() -> UICollectionViewCell.Type    
}

public protocol CollectionCellProtocol: NSObjectProtocol {
    func updateWithObject(_ object: CollectionCellObject) -> Bool
    
    static func reuseIdentifier() -> String
}

extension UICollectionView {
    func registerCollectionCells(cells: [CollectionCellProtocol.Type]) {
        for c in cells {
            register(c, forCellWithReuseIdentifier: c.reuseIdentifier())
        }
    }
    
    func registerSectionHeader(cls: CollectionSupplementaryView.Type) {
        register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cls.reuseIdentifier())
    }
    
    func registerSectionFooter(cls: CollectionSupplementaryView.Type) {
        register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cls.reuseIdentifier())
    }
}

/**
 The TableCellFactory class is the binding logic between Objects and Cells and should be used as the
 delegate for a TableModel.
 A contrived example of creating an empty model with the singleton TableCellFactory instance.
 let model = TableModel(delegate: TableCellFactory.tableModelDelegate())
 */
public class CollectionCellFactory : NSObject {
    
    /**
     Returns a singleton TableModelDelegate instance for use as a TableModel delegate.
     */
    public class func collectionModelDelegate() -> CollectionModelDelegate {
        return self.shared
    }
}

extension CollectionCellFactory : CollectionModelDelegate {
    public func collectionModel(_ collectionModel: CollectionModel, viewForSupplementaryElementForCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath, object: AnyObject) -> UICollectionReusableView? {
        
        guard let item = object as? CollectionSupplementaryElement else {
            return nil
        }
        
        guard let viewClass = item.viewClass() as? CollectionSupplementaryView.Type else {
            return nil
        }
        
        let identifier = viewClass.reuseIdentifier()
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        
        if let s = v as? CollectionSupplementaryView {
            s.updateWithObject(item)
        }
        
        return v
    }
    
    public func collectionModel(_ collectionModel: CollectionModel, cellForCollectionView collectionView: UICollectionView, indexPath: IndexPath, object: AnyObject) -> UICollectionViewCell? {
        
        guard let object = object as? CollectionCellObject else {
            return nil
        }
        
        return self.cell(object.cellClass(), collectionView: collectionView, indexPath: indexPath, object: object)
    }
}

// Private
extension CollectionCellFactory {
    
    /**
     Returns a cell for a given object.
     */
    private func cell(_ cellClass: UICollectionViewCell.Type, collectionView: UICollectionView, indexPath: IndexPath, object: CollectionCellObject) -> UICollectionViewCell? {
        
        guard let cellClass = cellClass as? CollectionCellProtocol.Type else {
            return nil
        }
        
        let identifier = cellClass.reuseIdentifier()
        
        // Recycle or create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        // Provide the object to the cell
        
        if let collectionCell = cell as? CollectionCellProtocol {
            _ = collectionCell.updateWithObject(object)
        }
        
        return cell
    }
}

// Singleton Pattern
extension CollectionCellFactory {
    private class var shared : CollectionCellFactory {
        struct Singleton {
            static let instance = CollectionCellFactory()
        }
        return Singleton.instance
    }
}
