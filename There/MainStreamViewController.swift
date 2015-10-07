//
//  MainStreamViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Parse

class MainStreamViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data: [Entry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

