//
//  AutoHeightTableCellTableViewCell.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class AutoHeightTableCellTableViewCell: TableCell {
    class func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat {
        guard let item = object as? TableItem else {
            return super.tableView(tableView, heightForObject: object, atIndexPath: indexPath)
        }
        
        if item.cellHeight == 0 {
            let cell = self.init(style: item.cellStyle(), reuseIdentifier: item.reuseIdentifier())
            
            item.cellHeight = cell.cellHeightForObject(item);
        }
        
        return item.cellHeight
    }
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellHeightForObject(_ object: TableItem) -> CGFloat {
        
        _ = updateWithObject(object)
        
        contentView.layoutIfNeeded()
        
        return contentView.frame.size.height
    }
}
