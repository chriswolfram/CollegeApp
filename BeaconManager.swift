//
//  BeaconManager.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BeaconManager: NSObject, CLLocationManagerDelegate
{
    let locManager: CLLocationManager
    let beaconRegion: CLBeaconRegion
    
    init(region: CLBeaconRegion, locationManager: CLLocationManager)
    {
        locManager = locationManager
        beaconRegion = region
        
        if CLLocationManager.isRangingAvailable()
        {
            locManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion)
    {
        if region == beaconRegion
        {
            manager.requestStateForRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
    {
        if region == beaconRegion && state == .Inside
        {
            print("entering")
            let notification = UILocalNotification()
            notification.alertBody = "entering"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            
            manager.startRangingBeaconsInRegion(beaconRegion)
        }
        
        else
        {
            print("exiting")
            let notification = UILocalNotification()
            notification.alertBody = "exiting"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            
            manager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        print("ranged")
        beacons.forEach
            {
                beacon in
                print(beacon.minor)
        }
    }
}