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
import ParseTwitterUtils

struct ParseAPI {
    static let ApplicationID = "ParseApplicationID"
    static let ClientKey = "ParseClientKey"
}

struct Twitter {
    static let ConsumerSecret = "TwitterConsumerSecret"
    static let ConsumerKey = "TwitterConsumerKey"
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

    // MARK: - Setup
    
    private func setupParse() {
        guard initParseFromPlist() else { exit(0) }
        
        PFUser.enableAutomaticUser()
        PFACL().setReadAccess(true, forUser: PFUser.currentUser())
        
//        initParseTwitter()
        
        registerParseSubclasses()
    }
    
    private func initParseFromPlist() -> Bool {
        
        guard let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist"),
            plist = NSDictionary(contentsOfFile: path),
            applicationId = plist[ParseAPI.ApplicationID] as? String,
            clientKey = plist[ParseAPI.ClientKey] as? String  else {
                return false
        }
                
        Parse.enableLocalDatastore()
        Parse.setApplicationId(applicationId, clientKey: clientKey)
        return true
    }
    
    private func initParseTwitter() {
        
      guard let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist"),
        plist = NSDictionary(contentsOfFile: path),
        secret = plist[Twitter.ConsumerSecret] as? String,
        key = plist[Twitter.ConsumerKey] as? String else {
            return
        }
            
        PFTwitterUtils.initializeWithConsumerKey(key, consumerSecret: secret)
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

