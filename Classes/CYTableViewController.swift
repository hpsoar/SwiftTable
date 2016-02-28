//
//  CYTableViewController.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class CYTableViewController: UIViewController {
    var tableView: UITableView!
    
    var tableModel: TableModel? {
        didSet {
            tableView.dataSource = tableModel
        }
    }
    
    var mutableTableModel: MutableTableModel? {
        if let t = tableModel as? MutableTableModel {
            return t
        }
        return nil
    }
    
    var tableDelegate: TableDelegate? {
        didSet {
            tableView.delegate = tableDelegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}
