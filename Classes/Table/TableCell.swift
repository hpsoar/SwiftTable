//
//  TableCell.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class TableItem : NSObject, TableCellObject {
    var cellHeight: CGFloat = 0.0
    
    func tableCellClass() -> UITableViewCell.Type? {
        return nil
    }
    
    func cellStyle() -> UITableViewCellStyle {
        return UITableViewCellStyle.default
    }
    
    func reuseIdentifier() -> String? {
        return nil
    }
}

class TableCell: UITableViewCell, TableCellProtocol {

    weak var item: TableCellObject?
    
    class func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat {
        return 44.0
    }
    
    static func reuseIdentifierForObject(_ object: TableCellObject) -> String {
        guard let identifier = object.reuseIdentifier() else {
            
            var identifier = NSStringFromClass(self)
            let style = object.cellStyle()
            identifier.append(String(style.rawValue))
            return identifier
        }
        
        return identifier
    }

    func updateWithObject(_ object: TableCellObject) -> Bool {
        self.item = object
        return true
    }
}
