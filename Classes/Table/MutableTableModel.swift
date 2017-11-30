//
//  MutableTableModel.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation

public class MutableTableModel : TableModel {
    var mutableModel: TableCellObjectModel
    
    public override init(sections: [TableCellObjectModel.Section], delegate: TableModelDelegate) {
        self.mutableModel = TableCellObjectModel(sections: sections)
        super.init(sections: [], delegate: delegate)
    }
    
    override func typedModel() -> TableCellObjectModel {
        return mutableModel
    }
}

extension MutableTableModel : MutableModelObjectInterface {
    public func addObject(_ object: AnyObject) -> [IndexPath] {
        return self.mutableModel.addObject(object)
    }
    
    public func addObjects(_ objects: [AnyObject]) -> [IndexPath] {
        return self.mutableModel.addObjects(objects)
    }
    
    public func addObject(_ object: AnyObject, toSection sectionIndex: Int) -> [IndexPath] {
        return self.mutableModel.addObject(object, toSection: sectionIndex)
    }
    
    public func addObjects(_ objects: [AnyObject], toSection sectionIndex: Int) -> [IndexPath] {
        return self.mutableModel.addObjects(objects, toSection: sectionIndex)
    }
    
    public func removeObjectAtIndexPath(_ indexPath: IndexPath) -> [IndexPath] {
        return self.mutableModel.removeObjectAtIndexPath(indexPath)
    }
    
    public func addSectionWithHeader(_ header: AnyObject) -> NSIndexSet {
        return self.mutableModel.addSectionWithHeader(header)
    }
    
    public func insertSectionWithHeader(_ header: AnyObject, atIndex sectionIndex: Int) -> NSIndexSet {
        return self.mutableModel.insertSectionWithHeader(header, atIndex: sectionIndex)
    }
    
    public func removeSectionAtIndex(_ sectionIndex: Int) -> NSIndexSet {
        return self.mutableModel.removeSectionAtIndex(sectionIndex)
    }
    
    public func setFooterForLastSection(_ footer: AnyObject) -> NSIndexSet {
        return self.mutableModel.setFooterForLastSection(footer)
    }
    
    public func setFooter(_ footer: AnyObject, atIndex sectionIndex: Int) -> NSIndexSet {
        return self.mutableModel.setFooter(footer, atIndex: sectionIndex)
    }
}
