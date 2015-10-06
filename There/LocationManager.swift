//
//  LocationManager.swift
//  There
//
//  Created by Michael Kavouras on 10/3/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedManager = LocationManager()
    
    var location: CLLocation?
    
    lazy private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.activityType = .Other
        manager.distanceFilter = 20.0
        manager.desiredAccuracy = 10.0
        manager.delegate = self
        return manager
    }()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
        }
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
}

extension CLLocation {
    
    private var LocationAccuracyThreshold: Double {
        return 65.0
    }
    
    func isValid() -> Bool {
        return horizontalAccuracy <= LocationAccuracyThreshold &&
            timestamp.timeIntervalSinceNow < 1
    }
}