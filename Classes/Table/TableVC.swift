//
//  CYTableViewController.swift
//  EveryDay
//
//  Created by HuangPeng on 1/16/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class TableVC: UIViewController {
    var tableView: UITableView!
    
    // Model
    var tableModel: TableModel? {
        didSet {
            tableView.dataSource = tableModel
        }
    }        
    
    // delegate
    var tableDelegate: TableDelegate? {
        didSet {
            tableView.delegate = tableDelegate
        }
    }
    
    // TODO: refresh ui interface
    
    // TODO: data loader interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}
