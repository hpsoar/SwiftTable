//
//  ModuleA.swift
//  TableDemo
//
//  Created by Huang Peng on 26/12/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

protocol NewsModuleDependency: NSObjectProtocol {
    func showProblem(id: String, navigator: Navigator)
}

class NewsModule: Module {
    
    // MARK - dependency
    
    static var dependecy: NewsModuleDependency!
    
    static func showProblem(id: String, navigator: Navigator) {
        dependecy.showProblem(id: id, navigator: navigator)
    }
    
    // MARK - api
    
    static func showNews(id: String, navigator: Navigator) {
        let controller = NewsDetailViewController()
        
        navigator.navigateTo(controller)
    }
}
