//
//  TableModel.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TableModelDelegate {
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
public class TableModel : NSObject {
    public typealias TableCellObjectModel = Model<AnyObject, AnyObject, AnyObject>
    
    let model: TableCellObjectModel
    weak var delegate: TableModelDelegate?
    
    public init(sections: [TableCellObjectModel.Section], delegate: TableModelDelegate) {
        self.model = TableCellObjectModel(sections: sections)
        self.delegate = delegate
        super.init()
    }
    
    public convenience init(list: [TableCellObject], delegate: TableModelDelegate) {
        self.init(sections: [(nil, objects: list)], delegate: delegate)
    }
    
    public convenience init(delegate: TableModelDelegate) {
        self.init(sections: [(nil, objects: [])], delegate: delegate)
    }
    
    func typedModel() -> TableCellObjectModel {
        return self.model
    }
}

extension TableModel : ModelObjectInterface {
    /**
     Returns the object at the given index path.
     Providing a non-existent index path will throw an exception.
     :param:   path    A two-index index path referencing a specific object in the receiver.
     :returns: The object found at path.
     */
    public func objectAtPath(_ path: IndexPath) -> AnyObject {
        return self.typedModel().objectAtPath(path)
    }
    
    /**
     Returns the index path for an object matching needle if it exists in the receiver.
     :param:   needle    The object to search for in the receiver.
     :returns: The index path of needle, if it was found, otherwise nil.
     */
    public func pathForObject(_ needle: AnyObject) -> IndexPath? {
        return self.typedModel().pathForObject(needle)
    }
    
    public func headerAtSection(_ section: NSInteger) -> AnyObject? {
        return self.typedModel().headerAtSection(section)
    }
    
    public func footerAtSection(_ section: NSInteger) -> AnyObject? {
        return self.typedModel().footerAtSection(section)
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
        let header = self.typedModel().headerAtSection(section)
        if let title = header as? String {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let footer = self.typedModel().footerAtSection(section)
        if let title = footer as? String {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object: AnyObject = self.typedModel().objectAtPath(indexPath)
        return self.delegate!.tableModel(self, cellForTableView: tableView, indexPath: indexPath, object: object)!
    }
}
