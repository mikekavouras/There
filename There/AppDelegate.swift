//
//  AppDelegate.swift
//  There
//
//  Created by Michael Kavouras on 10/1/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts

struct ParseAPI {
    static let ApplicationID = "yhcDXuJR178ADzrgYKjH7YO5FAhTXNKGYwtflJUW"
    static let ClientKey = "2xgmdMbksrMA7Rj3l2WjU7LtQ3oYZzsy780q9zmO"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupParse()
        setupApplicationShortcuts()
        
        return true
    }
    
    // MARK: - Setup
    
    private func setupParse() {
        registerParseSubclasses()
        Parse.setApplicationId(ParseAPI.ApplicationID, clientKey: ParseAPI.ClientKey)
    }
    
    private func registerParseSubclasses() {
        Entry.registerSubclass()
    }
    
    private func setupApplicationShortcuts() {
        if #available(iOS 9.0, *) {

            let photoItem = UIMutableApplicationShortcutItem(type: "com.mikekavouras.photo", localizedTitle: "Add Photo", localizedSubtitle: nil, icon: nil, userInfo: nil)
            let videoItem = UIMutableApplicationShortcutItem(type: "com.mikekavouras.video", localizedTitle: "Add Video", localizedSubtitle: nil, icon: nil, userInfo: nil)
            let items = [photoItem, videoItem]

            UIApplication.sharedApplication().shortcutItems = items
        }
        
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CreateEntryControllerIdentifier") as! CreateEntryViewController
        
        let navController = UINavigationController(rootViewController: viewController)
        window!.rootViewController!.presentViewController(navController, animated: false, completion: {
            viewController.presentFromShortcutItem(shortcutItem)
        })
        
        completionHandler(true)
        
    }

}

