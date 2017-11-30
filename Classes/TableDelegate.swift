//
//  TableDelegate.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class TableDelegate: Actions {
    var tableModel: TableModel?        
    
    init(tableModel: TableModel?) {
        self.tableModel = tableModel
        super.init()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createSectionViewForSectionObject(tableModel?.headerAtSection(section))
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.createSectionViewForSectionObject(tableModel?.footerAtSection(section))
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        var cellHeight = tableView.rowHeight
        if tableModel != nil {
            let object = tableModel!.objectAtPath(indexPath) as! TableCellObject
            let cellClass = object.tableCellClass() as? TableCellProtocol.Type
            if cellClass != nil {
                let height = cellClass!.tableView(tableView, heightForObject: object, atIndexPath: indexPath)
                if height > 0 {
                    cellHeight = height
                }
            }
        }
        return cellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    private func createSectionViewForSectionObject(_ object: Any?) -> UIView? {
        if let sectionObject = object as? TableSectionHeaderObject {
            let viewClass = sectionObject.viewClass()
            let view = viewClass.init(frame: .zero)
            if let headerView = view as? TableSectionHeaderView {
                headerView.updateViewWithObject(sectionObject)
            }
            return view
        }
        return nil
    }
    
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        return nil
    }
}
