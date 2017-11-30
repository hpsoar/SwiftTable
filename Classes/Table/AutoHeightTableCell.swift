//
//  AutoHeightTableCellTableViewCell.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class AutoHeightTableCell: TableCell {
    override class func tableView(_ tableView: UITableView, heightForObject object:TableCellObject, atIndexPath indexPath:IndexPath) -> CGFloat {
        guard let item = object as? TableItem else {
            return super.tableView(tableView, heightForObject: object, atIndexPath: indexPath)
        }
        
        if item.cellHeight == 0 {
            let cell = self.init(style: item.cellStyle(), reuseIdentifier: item.reuseIdentifier())
            
            item.cellHeight = cell.cellHeightForObject(item);
        }
        print("\(item.cellHeight)")
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
        
        let contentWidth = contentView.frame.size.width
        
        let widthFenceConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: contentWidth)
        
        // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
        
        var edgeConstraints:[NSLayoutConstraint]? = nil
        
        if #available(iOS 10.2, *) {

            // To avoid confilicts, make width constraint softer than required (1000)
            widthFenceConstraint.priority = UILayoutPriority(UILayoutPriority.required.rawValue - 1);
            
            // Build edge constraints
            let leftConstraint = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
            
            let rightConstraint = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let constraints = [leftConstraint, rightConstraint, topConstraint, bottomConstraint]
            
            addConstraints(constraints)
            
            edgeConstraints = constraints
        }
        
        contentView.addConstraint(widthFenceConstraint)
        
        let fittingHeight = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        contentView.removeConstraint(widthFenceConstraint)
        if let constraints = edgeConstraints {
            removeConstraints(constraints)
        }
        
        return fittingHeight
    }
}
