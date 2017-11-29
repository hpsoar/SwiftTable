//
//  TableCellFactory.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TableSectionHeaderObject {
    func viewClass() -> UIView.Type
}

@objc public protocol TableSectionHeaderView {
    func updateViewWithObject(_ object: TableSectionHeaderObject)
    
    static func tableView(_ tableView: UITableView, heightForObject object:TableSectionHeaderObject, atSection section:NSInteger)
}

typealias TableSectionFooterObject = TableSectionHeaderObject
typealias TableSectionFooterView = TableSectionHeaderView

@objc public protocol TableCellObject {
    func tableCellClass() -> UITableViewCell.Type
    func cellStyle() -> UITableViewCellStyle
    func reuseIdentifier() -> String?
}

extension TableCellObject {
    func tableCellClass() -> UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    func cellStyle() -> UITableViewCellStyle {
        return UITableViewCellStyle.default
    }
    func reuseIdentifier() -> String? {
        return nil
    }
}

@objc public protocol TableCell {
    func updateCellWithObject(_ object: TableCellObject) -> Bool
    
    static func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat;
}

extension TableCell {
    func updateCellWithObject(object: TableCellObject) -> Bool {
        return true
    }
    
    static func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat {
        return 44.0
    }
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
        
        return self.cell(object.tableCellClass(), tableView: tableView, indexPath: indexPath, object: object as? TableCellObject)
    }
}

// Private
extension TableCellFactory {
    
    /**
     Returns a cell for a given object.
     */
    private func cell(_ tableCellClass: UITableViewCell.Type, tableView: UITableView, indexPath: IndexPath, object: TableCellObject?) -> UITableViewCell? {
        guard let object = object else {
            return nil
        }
        
        guard let identifier = cellIdentifier(tableCellClass, object: object) else {
            return nil
        }
        
        let style = object.cellStyle()

        // Recycle or create the cell
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = tableCellClass.init(style: style, reuseIdentifier: identifier)
        }
        
        // Provide the object to the cell
        
        if let tableCell = cell as? TableCell {
            _ = tableCell.updateCellWithObject(object)
        }
        
        return cell!
    }
    
    private func cellIdentifier(_ tableCellClass: UITableViewCell.Type, object: TableCellObject) -> String? {
        var identifier = object.reuseIdentifier()
        
        // Append object class to reuse identifier
        if identifier == nil {
            identifier = NSStringFromClass(tableCellClass)
            let style = object.cellStyle()
            identifier!.append(String(style.rawValue))
        }
        return identifier
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
