//
//  TableModel.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit
/*
 */

/*
 * TableModel is the data Source
 */

public protocol TableModelDelegate: NSObjectProtocol {
    func tableModel(_ tableModel: TableModel, cellForTableView tableView: UITableView, indexPath: IndexPath, object: AnyObject) -> UITableViewCell?
}


/**
 An instance of TableModel is meant to be the data source for a UITableView.
 TableModel stores a collection of sectioned objects. Each object must conform to the TableCellObject
 protocol. Each section can have a header and/or footer title.
 Sections are tuples of the form:
 ((header: String?, footer: String?)?, objects: [TableCellObject])
 When provided as the dataSource for a UITableView, the following occurs each time a cell needs to be
 displayed:
 - The table view requests a cell for a given index path.
 - The model retrieves the object corresponding to the index path and:
 - determines the object's cell class,
 - recycles or instantiates the cell, and
 - returns the cell to the table view.
 */
public class TableModel : TypedModel {
    
    weak var delegate: TableModelDelegate!
    
    public init(sections: [CellObjectModel.Section], delegate: TableModelDelegate) {
        self.delegate = delegate
        super.init(sections: sections)
    }
    
    public convenience init(list: [AnyObject], delegate: TableModelDelegate) {
        self.init(sections: [(nil, objects: list)], delegate: delegate)
    }
    
    public convenience init(delegate: TableModelDelegate) {
        self.init(sections: [], delegate: delegate)
    }        
}

extension TableModel : UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.typedModel().sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typedModel().sections[section].objects.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // if you want a section header title, use String as Header Type
        let header = self.typedModel().headerAtSection(section)
        if let title = header as? String {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        // if you want a section footer title, use String as Footer Type
        let footer = self.typedModel().footerAtSection(section)
        if let title = footer as? String {
            return title
        }
        return nil
    }
    
    // TODO: handle can edit, currently you can support it by subclass TableModel
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // TODO: handle can move, currently you can support it by subclass TableModel
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object: AnyObject = self.typedModel().objectAtPath(indexPath)
        return self.delegate.tableModel(self, cellForTableView: tableView, indexPath: indexPath, object: object)!
    }
}
