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
    
    //var locManager = CLLocationManager()
    //var mapController: MapController?
    //var tourController: TourViewController?
            
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //Setup the location manager
        //locManager.delegate = self
        //locManager.requestWhenInUseAuthorization()
        
        return true
    }
    
    /*func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        mapController?.locationManager(manager, didChangeAuthorizationStatus: status)
    }*/
}