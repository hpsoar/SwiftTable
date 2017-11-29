//
//  Actions.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation

public typealias Action = (_ object: AnyObject, _ indexPath: IndexPath) -> Bool
public typealias BoolTargetSignature = (_ object: NSObject, _ indexPath: IndexPath) -> Bool
public typealias VoidTargetSignature = (_ object: NSObject, _ indexPath: IndexPath) -> ()

protocol TargetAction {
    func performAction(object: NSObject, indexPath: IndexPath) -> Bool?
}

private struct BoolObjectAction <T: AnyObject> : TargetAction {
    weak var target: T?
    let action: (T) -> BoolTargetSignature
    
    func performAction(object: NSObject, indexPath: IndexPath) -> Bool? {
        if let t = target {
            return action(t)(object, indexPath)
        }
        return nil
    }
}

private struct VoidObjectAction <T: AnyObject> : TargetAction {
    weak var target: T?
    let action: (T) -> VoidTargetSignature
    
    func performAction(object: NSObject, indexPath: IndexPath) -> Bool? {
        if let t = target {
            action(t)(object, indexPath)
        }
        return nil
    }
}

struct ObjectActions {
    var tap: Action?
    var navigate: Action?
    var detail: Action?
    
    var tapSelector: TargetAction?
    var navigateSelector: TargetAction?
    var detailSelector: TargetAction?
    
    var enabled: Bool = true
    
    init() {}
    
    func hasActions() -> Bool {
        return (hasTapAction() || hasNavigateAction() || hasDetailAction())
    }
    
    func hasTapAction() -> Bool {
        return (tap != nil || tapSelector != nil)
    }
    
    func hasNavigateAction() -> Bool {
        return (navigate != nil || navigateSelector != nil)
    }
    
    func hasDetailAction() -> Bool {
        return (detail != nil || detailSelector != nil)
    }
    
    func performTapAction(object: NSObject, indexPath: IndexPath) -> Bool? {
        if !hasTapAction() {
            return nil
        }
        var shouldDeselect = false
        if let tap = tap {
            shouldDeselect = shouldDeselect || tap(object, indexPath)
        }
        if let tapSelector = tapSelector {
            shouldDeselect = shouldDeselect || tapSelector.performAction(object: object, indexPath: indexPath)!
        }
        return shouldDeselect
    }
    
    func performNavigateAction(object: NSObject, indexPath: IndexPath) {
        _ = navigate?(object, indexPath)
        _ = navigateSelector?.performAction(object: object, indexPath: indexPath)
    }
    
    func performDetailAction(object: NSObject, indexPath: IndexPath) {
        _ = detail?(object, indexPath)
        _ = detailSelector?.performAction(object: object, indexPath: indexPath)
    }
    
    mutating func unionWith(otherActions: ObjectActions?) {
        if nil == otherActions {
            return
        }
        if (tap == nil && otherActions!.tap != nil) {
            tap = otherActions!.tap
        }
        if (navigate == nil && otherActions!.navigate != nil) {
            navigate = otherActions!.navigate
        }
        if (detail == nil && otherActions!.detail != nil) {
            detail = otherActions!.detail
        }
        if (tapSelector == nil && otherActions!.tapSelector != nil) {
            tapSelector = otherActions!.tapSelector
        }
        if (navigateSelector == nil && otherActions!.navigateSelector != nil) {
            navigateSelector = otherActions!.navigateSelector
        }
        if (detailSelector == nil && otherActions!.detailSelector != nil) {
            detailSelector = otherActions!.detailSelector
        }
    }
    
    mutating func reset() {
        self.tap = nil
        self.navigate = nil
        self.detail = nil
        self.tapSelector = nil
        self.navigateSelector = nil
        self.detailSelector = nil
    }
}

public class Actions : NSObject {
    var objectToAction = Dictionary<Int, ObjectActions>()
    var classToAction = Dictionary<String, ObjectActions>()
}

extension Actions {
    
    // Querying Actionable State
    
    public func isActionableObject<O>(_ object: O) -> Bool where O: AnyObject, O: Hashable {
        return self.actionsForObject(object).hasActions()
    }
    
    // Enabling/Disabling Actions
    
    public func setObject<O>(_ object: O, enabled: Bool) where O: AnyObject, O: Hashable {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.enabled = enabled
    }
    
    public func setClass(_ theClass: AnyClass, enabled: Bool) {
        let theClassName = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(theClassName)
        self.classToAction[theClassName]!.enabled = enabled
    }
    
    // Object Mapping
    
    public func attachToObject<O>(_ object: O, tap: @escaping Action) -> O where O: AnyObject, O: Hashable {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.tap = tap
        return object
    }
    
    public func attachToObject<O>(_ object: O, navigate: @escaping Action) -> O where O: AnyObject, O: Hashable {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.navigate = navigate
        return object
    }
    
    public func attachToObject<O>(_ object: O, detail: @escaping Action) -> O where O: AnyObject, O: Hashable {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.detail = detail
        return object
    }
    
    public func attachToObject<O, T>(_ object: O, target: T, tap: @escaping (T) -> BoolTargetSignature) -> O where O: AnyObject, O: Hashable, T: AnyObject {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.tapSelector = BoolObjectAction(target: target, action: tap)
        return object
    }
    
    public func attachToObject<O, T>(_ object: O, target: T, navigate: @escaping (T) -> VoidTargetSignature) -> O where O: AnyObject, O: Hashable, T: AnyObject {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.navigateSelector = VoidObjectAction(target: target, action: navigate)
        return object
    }
    
    public func attachToObject<O, T>(_ object: O, target: T, detail: @escaping (T) -> VoidTargetSignature) -> O where O: AnyObject, O: Hashable, T: AnyObject {
        self.ensureActionsExistForObject(object)
        self.objectToAction[object.hashValue]!.detailSelector = VoidObjectAction(target: target, action: detail)
        return object
    }
    
    // Class Mapping
    
    public func attachToClass(_ theClass: AnyClass, tap: @escaping Action) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.tap = tap
        return theClass
    }
    
    public func attachToClass(_ theClass: AnyClass, navigate: @escaping Action) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.navigate = navigate
        return theClass
    }
    
    public func attachToClass(_ theClass: AnyClass, detail: @escaping Action) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.detail = detail
        return theClass
    }
    
    public func attachToClass<T: AnyObject>(_ theClass: AnyClass, target: T, tap: @escaping (T) -> BoolTargetSignature) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.tapSelector = BoolObjectAction(target: target, action: tap)
        return theClass
    }
    
    public func attachToClass<T: AnyObject>(theClass: AnyClass, target: T, navigate: @escaping (T) -> VoidTargetSignature) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.navigateSelector = VoidObjectAction(target: target, action: navigate)
        return theClass
    }
    
    public func attachToClass<T: AnyObject>(_ theClass: AnyClass, target: T, detail: @escaping (T) -> VoidTargetSignature) -> AnyClass {
        let className = NSStringFromClass(theClass)
        self.ensureActionsExistForClass(className)
        self.classToAction[className]!.detailSelector = VoidObjectAction(target: target, action: detail)
        return theClass
    }
    
    // Removing Actions
    
    public func removeAllActionsForObject<O>(_ object: O) where O: AnyObject, O: Hashable {
        self.objectToAction[object.hashValue]?.reset()
    }
    
    public func removeAllActionsForClass(theClass: AnyClass) {
        self.classToAction[NSStringFromClass(theClass)]?.reset()
    }
}

// Internal
extension Actions {
    /**
     Returns all attached actions for a given object.
     
     "Attached actions" are:
     1) actions attached to the provided object, and
     2) actions attached to classes in the object's class ancestry.
     
     Priority is as follows:
     
     1) Object actions
     2) Object.class actions
     3) Object.superclass.class actions
     4) etc... up the class ancestry
     ## Example
     Consider the following class hierarchy:
     NSObject -> Widget (tap) -> DetailWidget (detail)
     The actions for an instance of DetailWidget are Widget's tap and DetailWidget's detail actions.
     Attaching a tap action to the DetailWidget instance would override the Widget tap action.
     */
    func actionsForObject<O>(_ object: O) -> ObjectActions where O: AnyObject, O: Hashable {
        var actions = ObjectActions()
        actions.unionWith(otherActions: self.objectToAction[object.hashValue])
        
        var objectClass: AnyClass! = type(of: object)
        while objectClass != nil {
            actions.unionWith(otherActions: self.classToAction[NSStringFromClass(objectClass)])
            objectClass = objectClass.superclass()
        }
        
        return actions
    }
}

// Private
extension Actions {
    private func ensureActionsExistForObject<O>(_ object: O) where O: AnyObject, O: Hashable {
        if self.objectToAction[object.hashValue] == nil {
            self.objectToAction[object.hashValue] = ObjectActions()
        }
    }
    
    private func ensureActionsExistForClass(_ theClass: String) {
        if self.classToAction[theClass] == nil {
            self.classToAction[theClass] = ObjectActions()
        }
    }
}
