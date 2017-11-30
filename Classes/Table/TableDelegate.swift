//
//  TableDelegate.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

/*
 * more UITableViewDelegate implementations
 * header/footer/cell height
 * header view/footer view
 */
class TableDelegate: TableActions {
    private let tableModel: TableModel        
    
    init(tableModel: TableModel) {
        self.tableModel = tableModel
        super.init()
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = tableView.rowHeight
        
        guard let object = tableModel.objectAtPath(indexPath) as? TableCellObject else {
            return cellHeight
        }
        
        guard let cellClass = object.tableCellClass() as? TableCellProtocol.Type else {
            return cellHeight
        }
        
        
        let height = cellClass.tableView(tableView, heightForObject: object, atIndexPath: indexPath)
        if height > 0 {
            cellHeight = height
        }
        
        return cellHeight
    }
    
    // MARK - header & footer
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createSectionViewForSectionObject(tableModel.headerAtSection(section))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.createSectionViewForSectionObject(tableModel.footerAtSection(section))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionViewHeightForSectionObject(tableModel.headerAtSection(section))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionViewHeightForSectionObject(tableModel.footerAtSection(section))
    }
    
    // MARK - private util
    
    private func sectionViewHeightForSectionObject(_ object: Any?) -> CGFloat {
        if let sectionObject = object as? TableSectionHeaderObject {
            return sectionObject.height()
        }
        return 0
    }
    
    private func createSectionViewForSectionObject(_ object: Any?) -> UIView? {
        if let sectionObject = object as? TableSectionHeaderObject {
            let viewClass = sectionObject.viewClass()
            let view = viewClass.init(frame: .zero)
            if let headerView = view as? TableSectionHeaderView {
                headerView.updateWithObject(sectionObject)
            }
            return view
        }
        return nil
    }        
}
