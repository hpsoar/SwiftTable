//
//  ModelBase.swift
//  TableDemo
//
//  Created by Huang Peng on 30/11/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

public class TypedModel: NSObject {
    public typealias CellObjectModel = Model<AnyObject, AnyObject, AnyObject>
    
    var mutableModel: CellObjectModel
    
    public init(sections: [CellObjectModel.Section]) {
        self.mutableModel = CellObjectModel(sections: sections)
        super.init()
    }
    
    public convenience init(list: [AnyObject]) {
        self.init(sections: [(nil, objects: list)])
    }
    
    public convenience override init() {
        self.init(sections: [(nil, objects: [])])
    }
    
    public func typedModel() -> CellObjectModel {
        return self.mutableModel
    }
}

extension TypedModel : ModelObjectInterface {
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

extension TypedModel : MutableModelObjectInterface {
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

