//
//  TableActions.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import Foundation
import UIKit

/*
 * extend actions to implement UITableViewDelegate
 */

extension Actions : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            _ = self.tableView(tableView, willDisplayCell: cell, forObject: object, atIndexPath: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            self.tableView(tableView, didSelectObject: object, atIndexPath: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let object = self.actionableObjectForTableView(tableView, atIndexPath: indexPath) {
            self.tableView(tableView, accessoryButtonTappedForObject: object, withIndexPath: indexPath)
        }
    }
}

// connect delegate methods to Actions
extension Actions {
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
extension Actions {
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
