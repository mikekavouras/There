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
        
        tableView.contentOffset = CGPointMake(0, 20)
    }
    
    // MARK: Pull selector delegate
    
    func pullSelectorTableView(tableView: PullSelectorTableView, didSelectOptionAtIndex index: Int) {
        var viewController: CreateEntryViewController?
        switch index {
            case 1: viewController = CreateController.Text(Storyboard.Main).instance()
            case 2: viewController = CreateController.Image(Storyboard.Main).instance()
            case 3: viewController = CreateController.Video(Storyboard.Main).instance()
            case 4: viewController = CreateController.Audio(Storyboard.Main).instance()
            default: break;
        }
        
        if let viewController = viewController {
            let navController = UINavigationController(rootViewController: viewController)
            presentViewController(navController, animated: true, completion: nil)
        }
    }

}
