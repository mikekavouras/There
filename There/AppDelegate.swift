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

struct ShortcutItem {
    static let NewEntry = "com.mikekavouras.There.NewEntry"
}

struct ImageAsset {
    static let NewDraft = "compose"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupParse()
        setupApplicationShortcuts()
        
        return true
    }
    
    func addFiniteBackgroundTask(task: (UIBackgroundTaskIdentifier) -> ()) {
        
        let application = UIApplication.sharedApplication()
        print("beginning background task")
        let bgIdentifier = application.beginBackgroundTaskWithExpirationHandler(nil)
        
        task(bgIdentifier)
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

            let icon = UIApplicationShortcutIcon(templateImageName: ImageAsset.NewDraft)
            let entryItem = UIMutableApplicationShortcutItem(type: ShortcutItem.NewEntry, localizedTitle: "New Entry", localizedSubtitle: nil, icon: icon, userInfo: nil)
            

            let items = [entryItem]

            UIApplication.sharedApplication().shortcutItems = items
        }
        
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CreateEntryControllerIdentifier") as! CreateEntryViewController
        
        let navController = UINavigationController(rootViewController: viewController)
        window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
        
        completionHandler(true)
    }

}

