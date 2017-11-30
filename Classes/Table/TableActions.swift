//
//  TableActions.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit

class WeakWrapper<T: AnyObject> : Hashable {
    var hashValue: Int
    
    static func ==(lhs: WeakWrapper<T>, rhs: WeakWrapper<T>) -> Bool {
        return lhs.value === rhs.value
    }
    
    weak var value : T?
    init (_ value: T) {
        self.value = value
        self.hashValue = ObjectIdentifier(value).hashValue
    }
}

/*
 * extend actions to implement UITableViewDelegate
 */

class TableActions: Actions, UITableViewDelegate {
    private var forwardDelegates = Set<WeakWrapper<UITableViewDelegate> >()
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            _ = self.tableView(tableView, willDisplayCell: cell, forObject: object, atIndexPath: indexPath)
        }
        
        for wrapper in forwardDelegates {            
            if let delegate = wrapper.value {
                if delegate.responds(to: #selector(TableActions.tableView(_:willDisplay:forRowAt:))) {
                    delegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            self.tableView(tableView, didSelectObject: object, atIndexPath: indexPath)
        }
        
        for wrapper in forwardDelegates {
            if let delegate = wrapper.value {
                if delegate.responds(to: #selector(TableActions.tableView(_:didSelectRowAt:))) {
                    delegate.tableView!(tableView, didSelectRowAt: indexPath)
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            self.tableView(tableView, accessoryButtonTappedForObject: object, withIndexPath: indexPath)
        }
        
        for wrapper in forwardDelegates {
            if let delegate = wrapper.value {
                if delegate.responds(to: #selector(TableActions.tableView(_:accessoryButtonTappedForRowWith:))) {
                    delegate.tableView!(tableView, accessoryButtonTappedForRowWith: indexPath)
                }
            }
        }
    }
}

// connect delegate methods to Actions
extension TableActions {
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forObject object: NSObject, atIndexPath indexPath: IndexPath) -> Bool {
        if !self.isActionableObject(object) {
            return false
        }
        
        cell.accessoryType = self.accessoryTypeForObject(object)
        cell.selectionStyle = self.selectionStyleForObject(object)
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectObject object: NSObject, atIndexPath indexPath: IndexPath) {
        let actions = self.actionsForObject(object)
        if !actions.hasActions() {
            return
        }
        
        if let shouldDeselect = actions.performTapAction(object: object, indexPath: indexPath) {
            if shouldDeselect {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        actions.performNavigateAction(object: object, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForObject object: NSObject, withIndexPath indexPath: IndexPath) {
        let actions = self.actionsForObject(object)
        if !actions.hasActions() {
            return
        }
        actions.performDetailAction(object: object, indexPath: indexPath)
    }
}

// Private
extension TableActions {
    private func accessoryTypeForObject(_ object: NSObject) -> UITableViewCellAccessoryType {
        let actions = self.actionsForObject(object)
        if actions.hasDetailAction() {
            return .detailDisclosureButton
        } else if actions.hasNavigateAction() {
            return .disclosureIndicator
        }
        return .none
    }
    
    private func selectionStyleForObject(_ object: NSObject) -> UITableViewCellSelectionStyle {
        let actions = self.actionsForObject(object)
        if (actions.hasNavigateAction() || actions.hasTapAction()) {
            return .default
        }
        return .none
    }
    
    private func actionableObjectForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> NSObject? {
        if let model = tableView.dataSource as? TableModel {
            if let object = model.objectAtPath(indexPath) as? NSObject {
                return object
            }
        }
        return nil
    }
}

// forwarding
extension TableActions {
    func forwardTo(_ delegate: UITableViewDelegate) {
        forwardDelegates.insert(WeakWrapper(delegate))
    }
    
    func removeForwardDelegate(_ delegate: UITableViewDelegate) {
        forwardDelegates.remove(WeakWrapper(delegate))
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        
        for wrapper in forwardDelegates {
            if let delegate = wrapper.value {                
                if delegate.responds(to: aSelector) {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        for wrapper in forwardDelegates {
            if let delegate = wrapper.value {
                if delegate.responds(to: aSelector) {
                    return delegate
                }
            }
        }
        return nil
    }
}
