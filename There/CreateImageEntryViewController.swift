//
//  CreateImageEntryViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class CreateImageEntryViewController: CreateEntryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        entry.typeMapped = .Image
        navigationItem.title = entry.type.capitalizedString
    }

}
