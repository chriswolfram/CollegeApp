//
//  ShuttlesViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 4/8/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit

class ShuttlesViewController: UIViewController, MKMapViewDelegate
{
    let apiKey = "NUZSb8yWMJmshdEsjpIQfm2ioTyKp1Oz3e5jsn5x2IT8Hv8MTZ"
    let agencyID = "84"
    
    var vehicles = [ShuttleVehicle]()
    var routes = [ShuttleRoute]()
    var stops = [ShuttleStop]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Setup and center mapView
        mapView.delegate = self
        mapView.setRegion(School.shuttleRegion, animated: false)
        
        //Get data about vehicles
        refreshAll()
    }
    
    func refreshVehicles(callback: Void->Void)
    {
        let urlComponents = NSURLComponents(URL: NSURL(string: "https://transloc-api-1-2.p.mashape.com/vehicles.json")!, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems =
        [
            NSURLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let request = NSMutableURLRequest(URL: urlComponents!.URL!)
        request.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                {
                    if let jsonVehicles = json["data"]?[self.agencyID] as? [AnyObject]
                    {
                        self.vehicles = jsonVehicles.map
                        {
                            (jsonVehicle: AnyObject) in
                            
                            let vehicle = ShuttleVehicle()
                            vehicle.speed = jsonVehicle["speed"] as? Float
                            vehicle.route = jsonVehicle["route_id"] as? String
                            vehicle.id = jsonVehicle["vehicle_id"] as? String
                            
                            if let location = jsonVehicle["location"] as? [String:Double], let lat = location["lat"], let long = location["lng"]
                            {
                                vehicle.location = CLLocation(latitude: lat, longitude: long)
                            }
                                
                            return vehicle
                        }
                    }
                }
            }
            
            callback()
        }.resume()
    }
    
    func refreshStaticInformation(callback: Void->Void)
    {
        //Setup queue for scheduling
        let operationQueue = NSOperationQueue()
        
        let routeOperation = NSBlockOperation(block: {})
        let segmentOperation = NSBlockOperation(block: {})
        let stopsOperation = NSBlockOperation(block: {})
        
        //Get route information
        let routeUrlComponents = NSURLComponents(URL: NSURL(string: "https://transloc-api-1-2.p.mashape.com/routes.json")!, resolvingAgainstBaseURL: false)
        
        routeUrlComponents?.queryItems =
        [
            NSURLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let routeRequest = NSMutableURLRequest(URL: routeUrlComponents!.URL!)
        routeRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        NSURLSession.sharedSession().dataTaskWithRequest(routeRequest)
        {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                {
                    if let jsonRoutes = json["data"]?[self.agencyID] as? [AnyObject]
                    {
                        self.routes = jsonRoutes.map
                        {
                            (jsonRoute: AnyObject) in
                            
                            let route = ShuttleRoute()
                            route.id = jsonRoute["route_id"] as? String
                            route.segmentIDs = (jsonRoute["segments"] as? [[String]])?.map({$0[0]})
                            
                            if let colorString = jsonRoute["color"] as? String, let color = self.colorFromString(colorString)
                            {
                                route.color = color
                            }
                            
                            return route
                        }
                    }
                }
            }
            
            operationQueue.addOperation(routeOperation)
        }.resume()
                
        //Get segment information
        var segments = [String:MKPolyline]()
        
        let segmentUrlComponents = NSURLComponents(URL: NSURL(string: "https://transloc-api-1-2.p.mashape.com/segments.json")!, resolvingAgainstBaseURL: false)
        
        segmentUrlComponents?.queryItems =
        [
            NSURLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let segmentRequest = NSMutableURLRequest(URL: segmentUrlComponents!.URL!)
        segmentRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        NSURLSession.sharedSession().dataTaskWithRequest(segmentRequest)
        {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                {
                    if let jsonSegments = json["data"] as? [String:String]
                    {
                        let segmentsTuples = jsonSegments.map
                        {
                            (segmentID: String, encodedString: String) in
                            
                            return (segmentID, self.polyLineWithEncodedString(encodedString))
                        }
                        
                        //Next line may be uneeded
                        segments = [:]
                        segmentsTuples.forEach({segments[$0.0] = $0.1})
                    }
                }
            }
            
            operationQueue.addOperation(segmentOperation)
        }.resume()
        
        //Get stop information
        var stopsDict = [String:ShuttleStop]()
        
        let stopsUrlComponents = NSURLComponents(URL: NSURL(string: "https://transloc-api-1-2.p.mashape.com/stops.json")!, resolvingAgainstBaseURL: false)
        
        stopsUrlComponents?.queryItems =
        [
            NSURLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let stopsRequest = NSMutableURLRequest(URL: stopsUrlComponents!.URL!)
        stopsRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        NSURLSession.sharedSession().dataTaskWithRequest(stopsRequest)
        {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                {
                    if let jsonStops = json["data"] as? [AnyObject]
                    {
                        jsonStops.forEach
                        {
                            jsonStop in
                            
                            let stop = ShuttleStop()
                            
                            stop.id = jsonStop["stop_id"] as? String
                            stop.name = jsonStop["name"] as? String
                            
                            if let location = jsonStop["location"] as? [String:Double], let lat = location["lat"], let long = location["lng"]
                            {
                                stop.location = CLLocation(latitude: lat, longitude: long)
                            }
                            
                            /*if let routeIDs = jsonStop["routes"] as? [String]
                            {
                                //TODO: USE DICTIONARY FOR ROUTES
                                stop.routes = self.routes.filter({if $0.id != nil {return routeIDs.contains($0.id!)} else {return false}})
                            }*/
                            
                            if stop.id != nil
                            {
                                stopsDict[stop.id!] = stop
                            }
                        }
                        
                        self.stops = Array(stopsDict.values)
                    }
                }
            }
            
            operationQueue.addOperation(stopsOperation)
        }.resume()
        
        let combineOperation = NSBlockOperation
        {
            self.routes.forEach
            {
                route in
                
                route.path = route.segmentIDs?.flatMap({segments[$0]})
                route.stops = route.stopIDs?.flatMap({stopsDict[$0]})
                
                route.stops?.forEach({$0.routes.append(route)})
            }
            
            callback()
        }
        
        combineOperation.addDependency(routeOperation)
        combineOperation.addDependency(segmentOperation)
        combineOperation.addDependency(stopsOperation)
        operationQueue.addOperation(combineOperation)
    }
    
    func refreshAll()
    {
        let operationQueue = NSOperationQueue()
        
        let routeOperation = NSBlockOperation(block: {})
        let vehicleOperation = NSBlockOperation(block: {})
        
        refreshStaticInformation({operationQueue.addOperation(routeOperation)})
        refreshVehicles({operationQueue.addOperation(vehicleOperation)})

        let displayOperation = NSBlockOperation
        {
            self.refreshShuttleMapView()
        }
        
        displayOperation.addDependency(routeOperation)
        displayOperation.addDependency(vehicleOperation)
        
        operationQueue.addOperation(displayOperation)
    }
    
    func refreshShuttleMapView()
    {
        //dispatch_async may be unneeded
        dispatch_async(dispatch_get_main_queue())
        {
            self.mapView.removeOverlays(self.mapView.overlays)
            
            self.routes.forEach({route in self.addShuttleOverlays(self.mapView, route: route)})
            self.stops.forEach({stop in self.addShuttleOverlays(self.mapView, stop: stop)})
            self.vehicles.forEach({vehicle in self.addShuttleOverlays(self.mapView, vehicle: vehicle)})
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if let vehicleOverlay = overlay as? ShuttleVehicleOverlay
        {
            let renderer = MKCircleRenderer(overlay: vehicleOverlay)
            renderer.fillColor = vehicleOverlay.vehicle.color
            
            return renderer
        }
        
        else if let stopOverlay = overlay as? ShuttleStopOverlay
        {
            let renderer = MKCircleRenderer(overlay: stopOverlay)
            renderer.fillColor = stopOverlay.stop.color
            
            return renderer
        }
        
        else if let routeSegmentOverlay = overlay as? ShuttleRouteSegmentOverlay
        {
            let renderer = MKPolylineRenderer(polyline: routeSegmentOverlay)
            renderer.strokeColor = routeSegmentOverlay.route.color
            renderer.lineWidth = 3.0
            
            return renderer
        }
        
        else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func addShuttleOverlays(mapView: MKMapView, vehicle: ShuttleVehicle)
    {
        if vehicle.location != nil
        {
            let overlay = ShuttleVehicleOverlay(centerCoordinate: vehicle.location!.coordinate, radius: 50)
            overlay.vehicle = vehicle
            
            mapView.addOverlay(overlay)
        }
    }
    
    func addShuttleOverlays(mapView: MKMapView, stop: ShuttleStop)
    {
        if stop.location != nil
        {
            let overlay = ShuttleStopOverlay(centerCoordinate: stop.location!.coordinate, radius: 50)
            overlay.stop = stop
            
            mapView.addOverlay(overlay)
        }
    }
    
    func addShuttleOverlays(mapView: MKMapView, route: ShuttleRoute)
    {
        let overlays = route.path?.map
        {
            (polyline: MKPolyline) -> ShuttleRouteSegmentOverlay in
            
            let overlay = ShuttleRouteSegmentOverlay.withPolyline(polyline)
            overlay.route = route
            
            return overlay
        }
        
        if overlays != nil
        {
            mapView.addOverlays(overlays!)
        }
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem)
    {
        refreshVehicles({self.refreshShuttleMapView()})
    }
    
    private func polyLineWithEncodedString(encodedString: String) -> MKPolyline {
        let bytes = (encodedString as NSString).UTF8String
        let length = encodedString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        var idx: Int = 0
        
        //var count = length / 4 //(original version)
        var count = length //(modified version)
        
        var coords = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(count)
        var coordIdx: Int = 0
        
        var latitude: Double = 0
        var longitude: Double = 0
        
        while (idx < length) {
            var byte = 0
            var res = 0
            var shift = 0
            
            repeat {
                byte = bytes[idx] - 0x3F
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            
            let deltaLat = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            latitude += Double(deltaLat)
            
            shift = 0
            res = 0
            
            repeat {
                byte = bytes[idx] - 0x3F
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            
            let deltaLon = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            longitude += Double(deltaLon)
            
            let finalLat: Double = latitude * 1E-5
            let finalLon: Double = longitude * 1E-5
            
            let coord = CLLocationCoordinate2DMake(finalLat, finalLon)
            coords[coordIdx] = coord
            coordIdx += 1
            
            if coordIdx == count {
                let newCount = count + 10
                let temp = coords
                coords.dealloc(count)
                coords = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(newCount)
                for index in 0..<count {
                    coords[index] = temp[index]
                }
                temp.destroy()
                count = newCount
            }
            
        }
        
        let polyLine = MKPolyline(coordinates: coords, count: coordIdx)
        coords.destroy()
        
        return polyLine
    }
    
    private func colorFromString(string: String) -> UIColor?
    {
        if string.characters.count != 6
        {
            return nil
        }
        
        let rString = string.substringWithRange(string.startIndex...string.startIndex.advancedBy(1))
        let gString = string.substringWithRange(string.startIndex.advancedBy(2)...string.startIndex.advancedBy(3))
        let bString = string.substringWithRange(string.startIndex.advancedBy(4)...string.startIndex.advancedBy(5))
        
        let r = Int(rString, radix: 16)
        let g = Int(gString, radix: 16)
        let b = Int(bString, radix: 16)
        
        if r == nil || g == nil || b == nil
        {
            return nil
        }
        
        return UIColor(red: CGFloat(r!)/255, green: CGFloat(g!)/255, blue: CGFloat(b!)/255, alpha: 1.0)
    }
}