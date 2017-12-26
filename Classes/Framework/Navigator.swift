//
//  Navigator.swift
//  TableDemo
//
//  Created by Huang Peng on 26/12/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

enum NavigationMode {
    case push
    case present
}

typealias NavigationCallback = () -> Void

class Navigator: NSObject {
    var mode : NavigationMode
    
    /**
     * if fromController is nil, we will find one
     */
    var fromController: UIViewController?
    
    var animated: Bool
    
    /**
     * callback on navigation is finished
     */
    var callback: NavigationCallback?
    
    init(mode: NavigationMode,
         fromController: UIViewController?,
         animated: Bool,
         callback: NavigationCallback?) {
        
        self.mode = mode
        self.fromController = fromController
        self.animated = animated
        self.callback = callback
    }
    
    convenience override init() {
        self.init(mode: .push, fromController: nil, animated: true, callback: nil)
    }
    
    func navigateTo(_ controller: UIViewController) {
        let from = getFromController()
        switch mode {
        case .push:
            if let navi = from.navigationController {
                navi.pushViewController(controller, animated: animated)
                // TODO: callback, delegate forward?
            } else {
                // TODO: assert?
            }
        case .present:
            from.present(controller, animated: animated, completion: callback)
        }
    }
    
    private func getFromController() -> UIViewController {
        if let c = fromController {
            return c
        }
        return UIViewController()
    }
}
