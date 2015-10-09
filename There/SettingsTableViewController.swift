//
//  SettingsTableViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/9/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var saveToCameraRollSwitch: UISwitch!
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveToCameraRollSwitchToggled(sender: UISwitch) {
        
    }
}
