//
//  AppDelegate.swift
//  testing
//
//  Created by Christopher Wolfram on 12/9/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate
{
    var window: UIWindow?
    
    var locManager = CLLocationManager()
    var mapController: MapController?
    var tourController: TourViewController?
    var beaconManager: BeaconManager!
    
    var beaconRegion: CLBeaconRegion!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        
        //Configure iBeacons
        beaconRegion = CLBeaconRegion(proximityUUID: School.beaconUUID, identifier: School.beaconUUID.UUIDString)
        beaconRegion.notifyEntryStateOnDisplay = true
        //Uncomment to enable beacons
        //beaconManager = BeaconManager(region: beaconRegion, locationManager: locManager)
        
        return true
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion)
    {
        beaconManager.locationManager(manager, didStartMonitoringForRegion: region)
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
    {
        beaconManager.locationManager(manager, didDetermineState: state, forRegion: region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        beaconManager.locationManager(manager, didRangeBeacons: beacons, inRegion: region)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        mapController?.locationManager(manager, didChangeAuthorizationStatus: status)
    }
}
