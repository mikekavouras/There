//
//  MainStreamViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class MainStreamViewController: UIViewController, PullSelectorTableViewDelegate {

    @IBOutlet weak var tableView: PullSelectorTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.pullSelectorDelegate = self
    }
    
    // MARK: Pull selector delegate
    
    func pullSelectorTableView(tableView: PullSelectorTableView, didSelectOptionAtIndex index: Int) {
        print(index)
    }
}
