//
//  ShuttleViewClasses.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 4/19/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit

protocol ShuttleOverlay: MKOverlay
{
    var highlighted: Bool {get set}
}

class ShuttleVehicle
{
    var location: CLLocation?
    var speed: Float?
    var routeID: String?
    var route: ShuttleRoute?
    var id: String?
}

class ShuttleVehicleOverlay: MKCircle, ShuttleOverlay
{
    var vehicle: ShuttleVehicle!
    var highlighted = false
    
    class func overlayFromVehicle(_ vehicle: ShuttleVehicle) -> ShuttleVehicleOverlay
    {
        var location = vehicle.location?.coordinate
        
        if location == nil
        {
            location = kCLLocationCoordinate2DInvalid
        }
        
        let overlay = ShuttleVehicleOverlay(center: location!, radius: 40)
        overlay.vehicle = vehicle
        
        return overlay
    }
}

class ShuttleVehicleRenderer: MKOverlayRenderer
{
    var vehicleOverlay: ShuttleVehicleOverlay!
    
    init(vehicleOverlay: ShuttleVehicleOverlay)
    {
        super.init(overlay: vehicleOverlay)
        
        self.vehicleOverlay = vehicleOverlay
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext)
    {
        let renderer = MKCircleRenderer(circle: vehicleOverlay)
        renderer.fillColor = vehicleOverlay.vehicle.route?.color
        
        renderer.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}

class ShuttleStop
{
    var location: CLLocation?
    var routeIDs: [String]?
    var routes: [ShuttleRoute] = []
    var name: String?
    var id: String?
}

class ShuttleStopOverlay: MKCircle, ShuttleOverlay
{
    var stop: ShuttleStop!
    var highlighted = false
    
    class func overlayFromStop(_ stop: ShuttleStop) -> ShuttleStopOverlay
    {
        var location = stop.location?.coordinate
        
        if location == nil
        {
            location = kCLLocationCoordinate2DInvalid
        }
        
        let overlay = ShuttleStopOverlay(center: location!, radius: 40)
        overlay.stop = stop
        
        return overlay
    }
}

class ShuttleStopRenderer: MKOverlayRenderer
{
    var stopOverlay: ShuttleStopOverlay!
    
    init(stopOverlay: ShuttleStopOverlay)
    {
        super.init(overlay: stopOverlay)
        
        self.stopOverlay = stopOverlay
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext)
    {
        var maxRadius = stopOverlay.radius
        if zoomScale > 0.1
        {
            if zoomScale >= 0.4
            {
                maxRadius /= 5
            }
            
            else
            {
                maxRadius /= Double(zoomScale)*10
            }
        }
        
        if stopOverlay.highlighted
        {
            maxRadius = 40
        }
        
        context.saveGState()
        
        let stopColors = Set(stopOverlay.stop.routes.map({$0.color}))
        let radiusStepSize = maxRadius/Double(stopColors.count+1)//(maxRadius - minRadius)/Double(stopColors.count)
        
        let borderWidth = 0.1*maxRadius/Double(stopColors.count)
        
        stopColors.enumerated().forEach
        {
            (i, color) in
            
            let circleRadius = maxRadius - Double(i)*radiusStepSize
            
            //Draw white border
            let contrastCircle = MKCircle(center: stopOverlay.coordinate, radius: circleRadius)
            
            let contrastPoint = point(for: contrastCircle.boundingMapRect.origin)
            context.translateBy(x: contrastPoint.x, y: contrastPoint.y)
            
            let contrastRenderer = MKCircleRenderer(circle: contrastCircle)
            contrastRenderer.fillColor = UIColor.white
            contrastRenderer.draw(mapRect, zoomScale: zoomScale, in: context)
            
            context.restoreGState()
            context.saveGState()
            
            //Draw colored disk
            let coloredCircle = MKCircle(center: stopOverlay.coordinate, radius: circleRadius-borderWidth)
            
            let coloredCirclePoint = point(for: coloredCircle.boundingMapRect.origin)
            context.translateBy(x: coloredCirclePoint.x, y: coloredCirclePoint.y)
            
            let coloredCircleRenderer = MKCircleRenderer(circle: coloredCircle)
            coloredCircleRenderer.fillColor = color
            coloredCircleRenderer.draw(mapRect, zoomScale: zoomScale, in: context)
            
            context.restoreGState()
            context.saveGState()
        }
    }
}

class ShuttleRouteSegmentsOverlay: NSObject, MKOverlay, ShuttleOverlay
{
    var segments: [ShuttleRouteSegment]!
    var highlighted = false
    
    init(segments: [ShuttleRouteSegment])
    {
        super.init()
        
        self.segments = segments
    }
    
    @objc var coordinate: CLLocationCoordinate2D = School.shuttleRegion.center
    
    fileprivate var privateBoundingMapRect: MKMapRect?
    @objc var boundingMapRect: MKMapRect
    {
        if privateBoundingMapRect == nil
        {
            segments.forEach
            {
                segment in
                
                if let path = segment.polyline
                {
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
        }
        
        if privateBoundingMapRect == nil
        {
            privateBoundingMapRect = MKMapRectNull
        }
        
        return privateBoundingMapRect!
    }
}

class ShuttleRouteSegmentsRenderer: MKOverlayRenderer
{
    var shuttleRouteSegmentOverlay: ShuttleRouteSegmentsOverlay!
    
    init(shuttleRouteSegmentOverlay: ShuttleRouteSegmentsOverlay)
    {
        super.init(overlay: shuttleRouteSegmentOverlay)
        
        self.shuttleRouteSegmentOverlay = shuttleRouteSegmentOverlay
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext)
    {
        context.saveGState()
        shuttleRouteSegmentOverlay.segments.forEach
        {
            segment in
            
            if let polyline = segment.polyline, segment.routes.count > 0
            {
                let point = self.point(for: polyline.boundingMapRect.origin)
                context.translateBy(x: point.x, y: point.y)
                
                let routeColors = Set(segment.routes.map({$0.color}))
                routeColors.enumerated().forEach
                {
                    (index, color) in
                    
                    let dashLength: CGFloat = 40
                    
                    let renderer = MKPolylineRenderer(polyline: polyline)
                    renderer.strokeColor = color
                    renderer.lineCap = .butt
                    renderer.lineDashPhase = dashLength*CGFloat(index)
                    renderer.lineDashPattern = [dashLength as NSNumber, dashLength*CGFloat(routeColors.count-1) as NSNumber]
                    renderer.lineWidth = 10
                    
                    var newZoomScale = zoomScale
                    if newZoomScale < 0.02
                    {
                        newZoomScale = 0.02
                    }

                    renderer.draw(mapRect, zoomScale: newZoomScale, in: context)
                }
                
                context.restoreGState()
                context.saveGState()
            }
        }
    }
}

class ShuttleRouteSegment
{
    var id: String?
    var polyline: MKPolyline?
    var routes: [ShuttleRoute] = []
    
    init(id: String, polyline: MKPolyline)
    {
        self.id = id
        self.polyline = polyline
    }
}

class ShuttleRoute
{
    var id: String?
    var path: [ShuttleRouteSegment]?
    var segmentIDs: [String]?
    var stopIDs: [String]?
    var stops: [ShuttleStop]?
    var color: UIColor = UIColor.red
}
