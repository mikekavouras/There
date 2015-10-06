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

}

