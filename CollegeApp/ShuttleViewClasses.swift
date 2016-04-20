//
//  ShuttleViewClasses.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 4/19/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit

class ShuttleVehicleOverlay: MKCircle
{
    var vehicle: ShuttleVehicle!
}

class ShuttleVehicle
{
    var location: CLLocation?
    var speed: Float?
    var route: String?
    var id: String?
    var color: UIColor = UIColor.redColor()
}

class ShuttleStopOverlay: MKCircle
{
    var stop: ShuttleStop!
}

class ShuttleStop
{
    var location: CLLocation?
    var routes: [ShuttleRoute] = []
    var name: String?
    var id: String?
    var color: UIColor = UIColor.redColor()
}

class ShuttleRouteSegmentOverlay: MKPolyline
{
    var route: ShuttleRoute!
    
    static func withPolyline(polyline: MKPolyline) -> ShuttleRouteSegmentOverlay
    {
        return ShuttleRouteSegmentOverlay(points: polyline.points(), count: polyline.pointCount)
    }
}

class ShuttleRoute
{
    var id: String?
    var path: [MKPolyline]?
    var segmentIDs: [String]?
    var stopIDs: [String]?
    var stops: [ShuttleStop]?
    var color: UIColor = UIColor.redColor()
}