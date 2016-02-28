//
//  TableViewModel.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation

protocol ModelObjectInterface {
    typealias ObjectType
    typealias HeaderType
    typealias FooterType
    func objectAtPath(path: NSIndexPath) -> ObjectType
    func pathForObject(needle: ObjectType) -> NSIndexPath?
    
    func headerAtSection(section: NSInteger) -> HeaderType?
    func footerAtSection(section: NSInteger) -> FooterType?
}

protocol MutableModelObjectInterface {
    typealias ObjectType
    typealias HeaderType
    typealias FooterType
    
    mutating func addObject(object: ObjectType) -> [NSIndexPath]
    mutating func addObjects(objects: [ObjectType]) -> [NSIndexPath]
    mutating func addObject(object: ObjectType, toSection sectionIndex: Int) -> [NSIndexPath]
    mutating func addObjects(objects: [ObjectType], toSection sectionIndex: Int) -> [NSIndexPath]
    mutating func removeObjectAtIndexPath(indexPath: NSIndexPath) -> [NSIndexPath]
    
    mutating func removeSectionAtIndex(sectionIndex: Int) -> NSIndexSet
    
    mutating func addSectionWithHeader(headerObject: HeaderType) -> NSIndexSet
    mutating func insertSectionWithHeader(headerObject: HeaderType, atIndex sectionIndex: Int) -> NSIndexSet
    
    mutating func setFooterForLastSection(footerObject: FooterType) -> NSIndexSet
    mutating func setFooter(footerObject: FooterType, atIndex sectionIndex: Int) -> NSIndexSet
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
    func objectAtPath(path: NSIndexPath) -> T {
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
    func pathForObject(needle: T) -> NSIndexPath? {
        for (sectionIndex, section) in self.sections.enumerate() {
            for (objectIndex, object) in section.objects.enumerate() {
                if object === needle {
                    return NSIndexPath(forRow: objectIndex, inSection: sectionIndex)
                }
            }
        }
        return nil
    }
    
    func headerAtSection(section: NSInteger) -> H? {
        assert(section < self.sections.count, "Section index out of bounds.")
        return self.sections[section].0?.header
    }
    
    func footerAtSection(section: NSInteger) -> F? {
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
    mutating func addObject(object: T) -> [NSIndexPath] {
        self.ensureMinimalState()
        return self.addObject(object, toSection: self.sections.count - 1)
    }
    
    mutating func addObjects(objects: [T]) -> [NSIndexPath] {
        return objects.map({ o in return self.addObject(o) }).reduce([], combine: +)
    }
    
    mutating func addObject(object: T, toSection sectionIndex: Int) -> [NSIndexPath] {
        assert(sectionIndex < self.sections.count, "Section index out of bounds.")
        
        self.sections[sectionIndex].objects.append(object)
        return [NSIndexPath(forRow: self.sections[sectionIndex].objects.count - 1, inSection: sectionIndex)]
    }
    
    mutating func addObjects(objects: [T], toSection sectionIndex: Int) -> [NSIndexPath] {
        return objects.map { (let object) in self.addObject(object, toSection: sectionIndex) }
            .reduce([], combine: +)
    }
    
    mutating func removeObjectAtIndexPath(indexPath: NSIndexPath) -> [NSIndexPath] {
        self.sections[indexPath.section].objects.removeAtIndex(indexPath.row)
        return [indexPath]
    }
    
    mutating func addSectionWithHeader(headerObject: H) -> NSIndexSet {
        self.sections.append(((header: headerObject, nil), objects: []))
        return NSIndexSet(index: self.sections.count - 1)
    }
    
    mutating func insertSectionWithHeader(headerObject: H, atIndex sectionIndex: Int) -> NSIndexSet {
        assert(sectionIndex < self.sections.count, "Section index out of bounds.")
        
        self.sections.insert(((header: headerObject, nil), objects: []), atIndex: sectionIndex)
        return NSIndexSet(index: sectionIndex)
    }
    
    mutating func removeSectionAtIndex(sectionIndex: Int) -> NSIndexSet {
        self.sections.removeAtIndex(sectionIndex)
        return NSIndexSet(index: sectionIndex)
    }
    
    mutating func setFooterForLastSection(footerObject: F) -> NSIndexSet {
        self.ensureMinimalState()
        return self.setFooter(footerObject, atIndex: self.sections.count - 1)
    }
    
    mutating func setFooter(footerObject: F, atIndex sectionIndex: Int) -> NSIndexSet {
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