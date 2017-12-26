//
//  QAModule.swift
//  TableDemo
//
//  Created by Huang Peng on 26/12/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

protocol QAModuleDependency: NSObjectProtocol {
    func showNews(id: String, navigator: Navigator)
}

class QAModule: Module {
    static var dependency: QAModuleDependency!
    
    static func showNews(id: String, navigator: Navigator) {
        dependency.showNews(id: id, navigator: navigator)
    }
    
    static func showProblem(id: String, navigator: Navigator) {
        let controller = QADetailVC()
        navigator.navigateTo(controller)
    }
}
