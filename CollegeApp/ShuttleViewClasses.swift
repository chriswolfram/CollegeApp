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

class ShuttleRoutesOverlay: NSObject, MKOverlay
{
    var routes: [ShuttleRoute]!
    
    init(routes: [ShuttleRoute])
    {
        super.init()
        self.routes = routes
    }
    
    @objc var coordinate: CLLocationCoordinate2D = School.shuttleRegion.center
    
    private var privateBoundingMapRect: MKMapRect?
    @objc var boundingMapRect: MKMapRect
    {
        if privateBoundingMapRect == nil
        {
            privateBoundingMapRect = routes.flatMap({$0.path?.map({$0.boundingMapRect})}).flatten().reduce(MKMapRect(), combine: {MKMapRectUnion($0, $1)})
        }
        
        return privateBoundingMapRect!
    }
}

class ShuttleRoutesRenderer: MKOverlayRenderer
{
    var shuttleRoutesOverlay: ShuttleRoutesOverlay!
    init(shuttleRoutesOverlay: ShuttleRoutesOverlay)
    {
        super.init(overlay: shuttleRoutesOverlay)
        
        self.shuttleRoutesOverlay = shuttleRoutesOverlay
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext)
    {
        //let renderer = MKPolylineRenderer(polyline: shuttleRoutesOverlay.routes[1].path![0])
        //renderer.strokeColor = UIColor.redColor()//route.color
        //renderer.lineWidth = 1000
        //renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
        
        let location = CLLocationCoordinate2D(latitude: 40.342810032686693, longitude: -74.653565)
        let circle = MKCircle(centerCoordinate: location, radius: 100)
        let renderer = MKCircleRenderer(circle: circle)
        renderer.fillColor = UIColor.greenColor()
        renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
        
        shuttleRoutesOverlay.routes.forEach
        {
            route in
            route.path?.forEach
            {
                polyline in
                
                let circle = MKCircle(centerCoordinate: polyline.coordinate, radius: 100)
                let renderer = MKCircleRenderer(circle: circle)
                renderer.fillColor = UIColor.greenColor()
                renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
                
                //let renderer = MKPolylineRenderer(polyline: polyline)
                //renderer.strokeColor = UIColor.redColor()//route.color
                //renderer.lineWidth = 1000
                //renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
            }
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