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
        var viewController: CreateEntryViewController?
        
        switch index {
            case 1: viewController = StoryboardController.CreateText(Storyboard.Text).instance()
            case 2: viewController = StoryboardController.CreateImage(Storyboard.Image).instance()
            case 3: viewController = StoryboardController.CreateVideo(Storyboard.Video).instance()
            case 4: viewController = StoryboardController.CreateAudio(Storyboard.Audio).instance()
            default: break;
        }
        
        if let viewController = viewController {
            let navController = UINavigationController(rootViewController: viewController)
            presentViewController(navController, animated: true, completion: nil)
        }
    }

}
