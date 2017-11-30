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
    func viewClass() -> UIView.Type
    func height() -> CGFloat
}

public protocol CollectionSupplementaryView : NSObjectProtocol {
    func updateWithObject(_ object: CollectionSupplementaryElement)
}

// cell object
public protocol CollectionCellObject: NSObjectProtocol {
    func cellClass() -> UICollectionViewCell.Type
    func reuseIdentifier() -> String?
}

public protocol CollectionCellProtocol: NSObjectProtocol {
    func updateWithObject(_ object: CollectionCellObject) -> Bool
    
    static func reuseIdentifierForObject(_ object: CollectionCellObject) -> String
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
        
        let identifier = cellClass.reuseIdentifierForObject(object)
        
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
