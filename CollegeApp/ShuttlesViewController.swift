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
                        
                        callback()
                    }
                }
            }
        }.resume()
    }
    
    func refreshRoutes(callback: Void->Void)
    {
        //Setup queue for scheduling
        let operationQueue = NSOperationQueue()
        
        let routeOperation = NSBlockOperation(block: {})
        let segmentOperation = NSBlockOperation(block: {})
        
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
                            
                            return route
                        }
                        
                        operationQueue.addOperation(routeOperation)
                    }
                }
            }
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
                        
                        segments = [:]
                        segmentsTuples.forEach({segments[$0.0] = $0.1})
                        
                        operationQueue.addOperation(segmentOperation)
                    }
                }
            }
        }.resume()
        
        let combineOperation = NSBlockOperation
        {
            self.routes.forEach
            {
                route in
                
                route.path = route.segmentIDs?.flatMap({segments[$0]})
            }
            
            callback()
        }
        
        combineOperation.addDependency(routeOperation)
        combineOperation.addDependency(segmentOperation)
        operationQueue.addOperation(combineOperation)
    }
    
    func refreshShuttleMapView()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.mapView.removeOverlays(self.mapView.overlays)

            //Show routes
            self.mapView.addOverlays(Array(self.routes.flatMap({$0.path}).flatten()))
            
            //Show vehicles
            let locationOverlays = self.vehicles.flatMap
            {
                (vehicle: ShuttleVehicle) -> MKCircle? in
            
                if vehicle.location != nil
                {
                    return MKCircle(centerCoordinate: vehicle.location!.coordinate, radius: 10)
                }
            
                return nil
            }

            self.mapView.addOverlays(locationOverlays)
        }
    }
    
    func refreshAll()
    {
        let operationQueue = NSOperationQueue()
        
        let routeOperation = NSBlockOperation(block: {})
        let vehicleOperation = NSBlockOperation(block: {})
        
        refreshRoutes({operationQueue.addOperation(routeOperation)})
        refreshVehicles({operationQueue.addOperation(vehicleOperation)})
        
        let displayOperation = NSBlockOperation
        {
            self.refreshShuttleMapView()
        }
        
        displayOperation.addDependency(routeOperation)
        displayOperation.addDependency(vehicleOperation)
        
        operationQueue.addOperation(displayOperation)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            renderer.lineWidth = 4.0
            return renderer
        }
        
        else if overlay is MKCircle
        {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            return renderer
        }
            
        else
        {
            return MKOverlayRenderer(overlay: overlay)
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
}

class ShuttleVehicle
{
    var location: CLLocation?
    var speed: Float?
    var route: String?
    var id: String?
}

class ShuttleStop
{
    
}

class ShuttleRoute
{
    var id: String?
    var path: [MKPolyline]?
    var segmentIDs: [String]?
}