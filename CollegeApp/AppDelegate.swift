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
    
    var beaconRegion: CLBeaconRegion!
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //Setup the location manager
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        //locManager.requestAlwaysAuthorization()
        
        //Configure iBeacons
        //beaconRegion = CLBeaconRegion(proximityUUID: School.beaconUUID, identifier: School.beaconUUID.UUIDString)
        //beaconRegion.notifyEntryStateOnDisplay = true
        //Uncomment to enable beacons on launch
        //beginBeaconSearching()
        
        return true
    }
    
    func beginBeaconSearching()
    {
        if CLLocationManager.isRangingAvailable()
        {
            locManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func endBeaconSearching()
    {
        locManager.stopMonitoringForRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion)
    {
        if region == beaconRegion
        {
            manager.requestStateForRegion(beaconRegion)
        }
    }
    
    //For iBeacons
    /*func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
    {
        if region == beaconRegion && state == .Inside
        {
            //Entering beacon range
            print("entering")
            
            if region is CLBeaconRegion
            {
                tourController?.didEnterRegion(region as! CLBeaconRegion)
            }
        }
        
        else
        {
            //Exiting beacon range
        }
    }*/
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        mapController?.locationManager(manager, didChangeAuthorizationStatus: status)
    }
}
