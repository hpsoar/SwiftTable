//
//  TableViewModel.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation

/*
 * Model is a generic indexPath based data Source,
 * it maintains model objects, with basic add & remove & query,
 * for header/footer/content object
 */
protocol ModelObjectInterface {
    associatedtype ObjectType
    associatedtype HeaderType
    associatedtype FooterType
    
    func objectAtPath(_ indexPath: IndexPath) -> ObjectType
    func pathForObject(_ object: ObjectType) -> IndexPath?
    
    func headerAtSection(_ section: NSInteger) -> HeaderType?
    func footerAtSection(_ section: NSInteger) -> FooterType?
}

protocol MutableModelObjectInterface {
    associatedtype ObjectType
    associatedtype HeaderType
    associatedtype FooterType
    
    mutating func addObject(_ object: ObjectType) -> [IndexPath]
    mutating func addObjects(_ objects: [ObjectType]) -> [IndexPath]
    mutating func addObject(_ object: ObjectType, toSection sectionIndex: Int) -> [IndexPath]
    mutating func addObjects(_ objects: [ObjectType], toSection sectionIndex: Int) -> [IndexPath]
    mutating func removeObjectAtIndexPath(_ indexPath: IndexPath) -> [IndexPath]
    
    mutating func removeSectionAtIndex(_ sectionIndex: Int) -> NSIndexSet
    
    mutating func addSectionWithHeader(_ headerObject: HeaderType) -> NSIndexSet
    mutating func insertSectionWithHeader(_ headerObject: HeaderType, atIndex sectionIndex: Int) -> NSIndexSet
    
    mutating func setFooterForLastSection(_ footerObject: FooterType) -> NSIndexSet
    mutating func setFooter(_ footerObject: FooterType, atIndex sectionIndex: Int) -> NSIndexSet
}

/**
 A Model is a container of objects arranged in sections with optional header and footer text.
 */
public struct Model <H: AnyObject, F: AnyObject, T : AnyObject> {
    public typealias Section = ((header: H?, footer: F?)?, objects: [T])
    
    var sections: [Section]
    
    /**
     Initializes the model with an array of sections.
     */
    init(sections: [Section]) {
        self.sections = sections
    }
    
    /**
     Initializes the model with a single section containing a list of objects.
     */
    init(list: [T]) {
        self.init(sections: [(nil, objects: list)])
    }
    
    /**
     Initializes the model with a single, object-less section.
     */
    init() {
        self.init(sections: [(nil, objects: [])])
    }
}

extension Model : ModelObjectInterface {
    /**
     Returns the object at the given index path.
     
     Providing a non-existent index path will throw an exception.
     
     :param:   path    A two-index index path referencing a specific object in the receiver.
     :returns: The object found at path.
     */
    func objectAtPath(_ path: IndexPath) -> T {
        assert(path.section < self.sections.count, "Section index out of bounds.")
        assert(path.row < self.sections[path.section].objects.count, "Row index out of bounds.")
        return self.sections[path.section].objects[path.row]
    }
    
    /**
     Returns the index path for an object matching needle if it exists in the receiver.
     This method is O(n). Please use with care.
     :param:   needle    The object to search for in the receiver.
     :returns: The index path of needle, if it was found, otherwise nil.
     */
    func pathForObject(_ needle: T) -> IndexPath? {
        for (sectionIndex, section) in self.sections.enumerated() {
            for (objectIndex, object) in section.objects.enumerated() {
                if object === needle {
                    return IndexPath(row: objectIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    func headerAtSection(_ section: NSInteger) -> H? {
        assert(section < self.sections.count, "Section index out of bounds.")
        return self.sections[section].0?.header
    }
    
    func footerAtSection(_ section: NSInteger) -> F? {
        assert(section < self.sections.count, "Section index out of bounds.")
        return self.sections[section].0?.footer
    }
}

extension Model : MutableModelObjectInterface {
    /**
     Add Object to the end of the last section
     
     - parameter object:
     
     - returns: indexPath of the object
     */
    mutating func addObject(_ object: T) -> [IndexPath] {
        self.ensureMinimalState()
        return self.addObject(object, toSection: self.sections.count - 1)
    }
    
    mutating func addObjects(_ objects: [T]) -> [IndexPath] {
        return objects.map({ o in return self.addObject(o) }).reduce([], +)
    }
    
    mutating func addObject(_ object: T, toSection sectionIndex: Int) -> [IndexPath] {
        assert(sectionIndex < self.sections.count, "Section index out of bounds.")
        
        self.sections[sectionIndex].objects.append(object)
        return [IndexPath(row: self.sections[sectionIndex].objects.count - 1, section: sectionIndex)]
    }
    
    mutating func addObjects(_ objects: [T], toSection sectionIndex: Int) -> [IndexPath] {
        return objects.map { (object) in self.addObject(object, toSection: sectionIndex) }
            .reduce([], +)
    }
    
    mutating func removeObjectAtIndexPath(_ indexPath: IndexPath) -> [IndexPath] {
        self.sections[indexPath.section].objects.remove(at: indexPath.row)
        return [indexPath]
    }
    
    mutating func addSectionWithHeader(_ headerObject: H) -> NSIndexSet {
        self.sections.append(((header: headerObject, nil), objects: []))
        return NSIndexSet(index: self.sections.count - 1)
    }
    
    mutating func insertSectionWithHeader(_ headerObject: H, atIndex sectionIndex: Int) -> NSIndexSet {
        assert(sectionIndex < self.sections.count, "Section index out of bounds.")
        
        self.sections.insert(((header: headerObject, nil), objects: []), at: sectionIndex)
        return NSIndexSet(index: sectionIndex)
    }
    
    mutating func removeSectionAtIndex(_ sectionIndex: Int) -> NSIndexSet {
        self.sections.remove(at: sectionIndex)
        return NSIndexSet(index: sectionIndex)
    }
    
    mutating func setFooterForLastSection(_ footerObject: F) -> NSIndexSet {
        self.ensureMinimalState()
        return self.setFooter(footerObject, atIndex: self.sections.count - 1)
    }
    
    mutating func setFooter(_ footerObject: F, atIndex sectionIndex: Int) -> NSIndexSet {
        assert(sectionIndex < self.sections.count, "Section index out of bounds.")
        
        if self.sections[sectionIndex].0 == nil {
            self.sections[sectionIndex].0 = (header: nil, footer: footerObject)
        } else {
            self.sections[sectionIndex].0!.footer = footerObject
        }
        
        return NSIndexSet(index: sectionIndex)
    }
}

// Private
extension Model {
    private mutating func ensureMinimalState() {
        if self.sections.count == 0 {
            self.sections.append((nil, objects: []))
        }
    }
}
