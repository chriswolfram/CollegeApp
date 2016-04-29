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
    var color: UIColor = UIColor.blueColor()
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

/*class ShuttleRouteSegmentOverlay: MKPolyline
{
    var route: ShuttleRoute!
    
    static func withPolyline(polyline: MKPolyline) -> ShuttleRouteSegmentOverlay
    {
        return ShuttleRouteSegmentOverlay(points: polyline.points(), count: polyline.pointCount)
    }
}*/

class ShuttleRouteOverlay: NSObject, MKOverlay
{
    var route: ShuttleRoute!
    
    init?(route: ShuttleRoute)
    {
        super.init()
        
        if route.path == nil || route.path!.count == 0
        {
            return nil
        }
        
        self.route = route
    }
    
    @objc var coordinate: CLLocationCoordinate2D = School.shuttleRegion.center
    
    private var privateBoundingMapRect: MKMapRect?
    @objc var boundingMapRect: MKMapRect
    {
        if privateBoundingMapRect == nil
        {
            if route.path != nil && route.path!.count > 0
            {
                route.path?.forEach
                {
                    path in
                    
                    if privateBoundingMapRect == nil
                    {
                        privateBoundingMapRect = path.boundingMapRect
                    }
                        
                    else
                    {
                        privateBoundingMapRect = MKMapRectUnion(privateBoundingMapRect!, path.boundingMapRect)
                    }
                }
            }
            
            else
            {
                privateBoundingMapRect = MKMapRectNull
            }
        }
        
        print(privateBoundingMapRect)
        
        return privateBoundingMapRect!
    }
}

class ShuttleRoutesRenderer: MKOverlayRenderer
{
    var shuttleRouteOverlay: ShuttleRouteOverlay!
    
    init(shuttleRouteOverlay: ShuttleRouteOverlay)
    {
        super.init(overlay: shuttleRouteOverlay)
        
        self.shuttleRouteOverlay = shuttleRouteOverlay
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext)
    {
        CGContextSaveGState(context)
        shuttleRouteOverlay.route.path?.forEach
        {
            polyline in
            
            let point = pointForMapPoint(polyline.boundingMapRect.origin)
            CGContextTranslateCTM(context, point.x, point.y)
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = shuttleRouteOverlay.route.color
            renderer.lineWidth = 5
            renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
            
            CGContextRestoreGState(context)
            CGContextSaveGState(context)
        }
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