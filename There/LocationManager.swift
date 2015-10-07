//
//  LocationManager.swift
//  There
//
//  Created by Michael Kavouras on 10/3/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

let MAX_DISTANCE_FILTER: CLLocationAccuracy = 100.0

protocol LocationManagerDelegate {
    func locationManagerDidUpdateLocations(manager: LocationManager)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    var delegate: LocationManagerDelegate?
    var location: CLLocation? {
        return self._latestLocation
    }
    
    // Constants
    private let DESIRED_ACCURACY: CLLocationDistance = 5.0
    private let DISTANCE_FILTER: CLLocationAccuracy = 20.0

    // Singleton
    static let sharedManager = LocationManager()
    
    // a whole bunch of nasty state to reduce the number of locations
    // that we process
    private var _latestLocation: CLLocation?
    private var latestLocation: CLLocation?
    private var previousLocation: CLLocation?
    private var retryCount = 0
    private let MAX_RETRY_COUNT = 5
    private var successfulLocationFoundTimer: NSTimer?
    
    lazy private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.activityType = .Other
        manager.distanceFilter = self.DISTANCE_FILTER
        manager.desiredAccuracy = self.DESIRED_ACCURACY
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        return manager
    }()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            successfulLocationFoundTimer?.invalidate()
            successfulLocationFoundTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "locationTimerFired:", userInfo: nil, repeats: false)
            
            if let l = latestLocation {
                if location.horizontalAccuracy <= l.horizontalAccuracy {
                    latestLocation = location
                }
            } else {
                latestLocation = location
            }
            
        }
    }
    
    @objc private func locationTimerFired(timer: NSTimer) {
        _latestLocation = latestLocation
        if latestLocation!.horizontalAccuracy >= MAX_DISTANCE_FILTER {
            retryCount++
            if retryCount <= MAX_RETRY_COUNT {
                print(">> FORCE UPDATE <<")
                forceLocationUpdate()
            } else {
                retryCount = 0
            }
        } else {
            if let previousLocation = previousLocation {
                if previousLocation.distanceFromLocation(latestLocation!) <= DISTANCE_FILTER  {
                    delegate?.locationManagerDidUpdateLocations(self)
                }
            } else {
                delegate?.locationManagerDidUpdateLocations(self)
            }
            self.previousLocation = latestLocation
        }
        
        latestLocation = nil
    }
    
    private func forceLocationUpdate() {
        locationManager.desiredAccuracy = 100
        locationManager.desiredAccuracy = DESIRED_ACCURACY
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        let _ = locationManager
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func start() {

        locationManager.startUpdatingLocation()
    }
    
    class func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
}
