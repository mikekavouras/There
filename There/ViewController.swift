//
//  ViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func viewControllerWithIdentifier(identifier: String, inStoryboard storyboard: String) -> UIViewController? {
       return UIStoryboard(name: storyboard, bundle: nil).instantiateViewControllerWithIdentifier(identifier)
    }
}