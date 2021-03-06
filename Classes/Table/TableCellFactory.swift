//
//  TableCellFactory.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit

/*
 * model to view mapping
 * object->header view/footer view
 * object->table cell
 */

public protocol TableSectionHeaderObject : NSObjectProtocol {
    func viewClass() -> UIView.Type
    func height() -> CGFloat
}

public protocol TableSectionHeaderView : NSObjectProtocol {
    func updateWithObject(_ object: TableSectionHeaderObject)
    
    static func tableView(_ tableView: UITableView, heightForObject object:TableSectionHeaderObject, atSection section:NSInteger) -> CGFloat
}

typealias TableSectionFooterObject = TableSectionHeaderObject
typealias TableSectionFooterView = TableSectionHeaderView

public protocol TableCellObject: NSObjectProtocol {
    func tableCellClass() -> UITableViewCell.Type?
    func cellStyle() -> UITableViewCellStyle
    func reuseIdentifier() -> String?
}

public protocol TableCellProtocol: NSObjectProtocol {
    func updateWithObject(_ object: TableCellObject) -> Bool
    
    static func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat;
    
    static func reuseIdentifierForObject(_ object: TableCellObject) -> String
}

/**
 The TableCellFactory class is the binding logic between Objects and Cells and should be used as the
 delegate for a TableModel.
 A contrived example of creating an empty model with the singleton TableCellFactory instance.
 let model = TableModel(delegate: TableCellFactory.tableModelDelegate())
 */
public class TableCellFactory : NSObject {
    
    /**
     Returns a singleton TableModelDelegate instance for use as a TableModel delegate.
     */
    public class func tableModelDelegate() -> TableModelDelegate {
        return self.shared
    }
}

extension TableCellFactory : TableModelDelegate {
    public func tableModel(_ tableModel: TableModel, cellForTableView tableView: UITableView, indexPath: IndexPath, object: AnyObject) -> UITableViewCell? {
        
        guard let object = object as? TableCellObject else {
            return nil
        }
        
        return self.cell(object.tableCellClass(), tableView: tableView, indexPath: indexPath, object: object)
    }
}

// Private
extension TableCellFactory {
    
    /**
     Returns a cell for a given object.
     */
    private func cell(_ tableCellClass: UITableViewCell.Type?, tableView: UITableView, indexPath: IndexPath, object: TableCellObject) -> UITableViewCell? {
        
        guard let cellClass = tableCellClass as? TableCellProtocol.Type else {
            print("\(tableCellClass!) is doesn't conform TableCellProtocol")
            return nil
        }
        
        let identifier = cellClass.reuseIdentifierForObject(object)
        
        let style = object.cellStyle()

        // Recycle or create the cell
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = tableCellClass!.init(style: style, reuseIdentifier: identifier)
        }
        
        // Provide the object to the cell
        
        if let tableCell = cell as? TableCellProtocol {
            _ = tableCell.updateWithObject(object)
        }
        
        return cell!
    }
}

// Singleton Pattern
extension TableCellFactory {
    private class var shared : TableCellFactory {
        struct Singleton {
            static let instance = TableCellFactory()
        }
        return Singleton.instance
    }
}
