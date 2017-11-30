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

class TableCell: UITableViewCell, TableCellProtocol {

    weak var item: TableCellObject?        

    func updateWithObject(_ object: TableCellObject) -> Bool {
        self.item = object
        return true
    }
}
