//
//  ShuttlesViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 4/8/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit

class ShuttlesViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource
{
    let apiKey = "NUZSb8yWMJmshdEsjpIQfm2ioTyKp1Oz3e5jsn5x2IT8Hv8MTZ"
    let agencyID = "84"
    
    var vehicles = [ShuttleVehicle]()
    var routes = [ShuttleRoute]()
    var stops = [ShuttleStop]()
    var segments = [ShuttleRouteSegment]()
    
    var highlightedOverlays = [ShuttleOverlay]()
    
    var internalSelectedOverlay: ShuttleOverlay?
    var selectedOverlay: ShuttleOverlay?
    {
        get
        {
            return internalSelectedOverlay
        }
        
        set(newValue)
        {
            internalSelectedOverlay = newValue
            
            if newValue == nil
            {
                tableViewHeight.constant = 0
            }
            
            else
            {
                tableViewHeight.constant = 300
                tableView.reloadData()
            }
            
            UIView.animate(withDuration: 0.3, animations: {self.tableView.layoutIfNeeded()})
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeight.constant = 0
        tableView.estimatedRowHeight = 47
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Setup and center mapView
        mapView.delegate = self
        mapView.setRegion(School.shuttleRegion, animated: false)
        
        //Get data about vehicles
        refreshAll()
    }
    
    func highlightOverlay(_ overlay: ShuttleOverlay)
    {
        overlay.highlighted = true
        highlightedOverlays.append(overlay)
    }
    
    func highlightOverlay(_ overlays: [ShuttleOverlay])
    {
        overlays.forEach({$0.highlighted = true})
        highlightedOverlays += overlays
    }
    
    func unhighlightOverlays()
    {
        highlightedOverlays.forEach({$0.highlighted = false})
        highlightedOverlays = []
    }
    
    func refreshVehicles(_ callback: @escaping (Void)->Void)
    {
        var urlComponents = URLComponents(url: URL(string: "https://transloc-api-1-2.p.mashape.com/vehicles.json")!, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems =
        [
            URLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let request = NSMutableURLRequest(url: urlComponents!.url!)
        request.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                {
                    if let jsonVehicles = json["data"]?[self.agencyID] as? [AnyObject]
                    {
                        self.vehicles = jsonVehicles.map
                        {
                            (jsonVehicle: AnyObject) in
                            
                            let vehicle = ShuttleVehicle()
                            vehicle.speed = jsonVehicle["speed"] as? Float
                            vehicle.routeID = jsonVehicle["route_id"] as? String
                            vehicle.id = jsonVehicle["vehicle_id"] as? String
                            
                            if let location = jsonVehicle["location"] as? [String:Double], let lat = location["lat"], let long = location["lng"]
                            {
                                vehicle.location = CLLocation(latitude: lat, longitude: long)
                            }
                            
                            if vehicle.routeID != nil
                            {
                                vehicle.route = self.routes.filter({$0.id == vehicle.routeID}).first
                            }
                            
                            return vehicle
                        }
                    }
                }
            }
            
            callback()
        })        
.resume()
    }
    
    func refreshStaticInformation(_ callback: @escaping (Void)->Void)
    {
        //Setup queue for scheduling
        let operationQueue = OperationQueue()
        
        let routeOperation = BlockOperation(block: {})
        let segmentOperation = BlockOperation(block: {})
        let stopsOperation = BlockOperation(block: {})
        
        //Get route information
        var routesDict = [String:ShuttleRoute]()
        
        var routeUrlComponents = URLComponents(url: URL(string: "https://transloc-api-1-2.p.mashape.com/routes.json")!, resolvingAgainstBaseURL: false)
        
        routeUrlComponents?.queryItems =
        [
            URLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let routeRequest = NSMutableURLRequest(url: routeUrlComponents!.url!)
        routeRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        URLSession.shared.dataTask(with: routeRequest as URLRequest, completionHandler: {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
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
                            
                            if route.id != nil
                            {
                                routesDict[route.id!] = route
                            }
                            
                            return route
                        }
                    }
                }
            }
            
            operationQueue.addOperation(routeOperation)
        })        
.resume()
        
        //Get segment information
        var segmentsDict = [String:ShuttleRouteSegment]()
        
        var segmentUrlComponents = URLComponents(url: URL(string: "https://transloc-api-1-2.p.mashape.com/segments.json")!, resolvingAgainstBaseURL: false)
        
        segmentUrlComponents?.queryItems =
        [
            URLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let segmentRequest = NSMutableURLRequest(url: segmentUrlComponents!.url!)
        segmentRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        URLSession.shared.dataTask(with: segmentRequest as URLRequest, completionHandler: {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                {
                    if let jsonSegments = json["data"] as? [String:String]
                    {
                        self.segments = jsonSegments.map
                        {
                            (segmentID: String, encodedString: String) in
                            
                            let segment = ShuttleRouteSegment(id: segmentID, polyline: self.polyLineWithEncodedString(encodedString))
                            
                            if segment.id != nil && segment.polyline != nil
                            {
                                segmentsDict[segment.id!] = segment
                            }
                            
                            return segment
                        }
                    }
                }
            }
            
            operationQueue.addOperation(segmentOperation)
        })        
.resume()
        
        //Get stop information
        var stopsDict = [String:ShuttleStop]()
        
        var stopsUrlComponents = URLComponents(url: URL(string: "https://transloc-api-1-2.p.mashape.com/stops.json")!, resolvingAgainstBaseURL: false)
        
        stopsUrlComponents?.queryItems =
        [
            URLQueryItem(name: "agencies", value: agencyID)
        ]
        
        let stopsRequest = NSMutableURLRequest(url: stopsUrlComponents!.url!)
        stopsRequest.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        URLSession.shared.dataTask(with: stopsRequest as URLRequest, completionHandler: {
            (jsonData, _, _) in
            
            if jsonData != nil
            {
                if let json = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
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
                            
                            stop.routeIDs = jsonStop["routes"] as? [String]
                            
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
        })        
.resume()
        
        let combineOperation = BlockOperation
        {
            self.routes.forEach
            {
                route in
                
                route.path = route.segmentIDs?.flatMap({segmentsDict[$0]?.routes.append(route); return segmentsDict[$0]})
                route.stops = route.stopIDs?.flatMap({stopsDict[$0]})
                
                route.stops?.forEach({$0.routes.append(route)})
            }
            
            self.stops.forEach
            {
                stop in
                
                if stop.routeIDs != nil
                {
                    stop.routes = stop.routeIDs!.flatMap({routesDict[$0]})
                }
            }
            
            self.vehicles.forEach
            {
                vehicle in
                
                if vehicle.routeID != nil
                {
                    vehicle.route = routesDict[vehicle.routeID!]
                }
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
        let operationQueue = OperationQueue()
        
        let routeOperation = BlockOperation(block: {})
        let vehicleOperation = BlockOperation(block: {})
        
        refreshStaticInformation({operationQueue.addOperation(routeOperation)})
        refreshVehicles({operationQueue.addOperation(vehicleOperation)})
        
        let displayOperation = BlockOperation
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
        DispatchQueue.main.async
        {
            self.mapView.removeOverlays(self.mapView.overlays)
            
            self.mapView.add(ShuttleRouteSegmentsOverlay(segments: self.segments))
            self.mapView.addOverlays(self.stops.map({ShuttleStopOverlay.overlayFromStop($0)}))
            self.mapView.addOverlays(self.vehicles.map({ShuttleVehicleOverlay.overlayFromVehicle($0)}))
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if let vehicleOverlay = overlay as? ShuttleVehicleOverlay
        {
            let renderer = ShuttleVehicleRenderer(vehicleOverlay: vehicleOverlay)
            
            return renderer
        }
            
        else if let stopOverlay = overlay as? ShuttleStopOverlay
        {
            let renderer = ShuttleStopRenderer(stopOverlay: stopOverlay)
            
            return renderer
        }
            
        else if let segmentsOverlay = overlay as? ShuttleRouteSegmentsOverlay
        {
            return ShuttleRouteSegmentsRenderer(shuttleRouteSegmentOverlay: segmentsOverlay)
        }
            
        else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem)
    {
        refreshVehicles({self.refreshShuttleMapView()})
    }
    
    @IBAction func mapPressed(_ sender: UITapGestureRecognizer)
    {
        let tapCoords = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        let tapLocation = CLLocation(latitude: tapCoords.latitude, longitude: tapCoords.longitude)
        
        unhighlightOverlays()
        
        mapView.overlays.forEach
        {
            overlay in
            
            if let stopOverlay = overlay as? ShuttleStopOverlay
            {
                let location = CLLocation(latitude: stopOverlay.coordinate.latitude, longitude: stopOverlay.coordinate.longitude)
                
                if location.distance(from: tapLocation) <= stopOverlay.radius
                {
                    //If there is a selected region, deselect it
                    if selectedOverlay != nil
                    {
                        mapView.remove(selectedOverlay!)
                        selectedOverlay!.highlighted = false
                        mapView.add(selectedOverlay!)
                    }
                    
                    //If the new overlay is different from the old one, select it.  Otherwise leave nothing selected.
                    if stopOverlay != selectedOverlay as? ShuttleStopOverlay
                    {
                        mapView.remove(stopOverlay)
                        stopOverlay.highlighted = true
                        mapView.add(stopOverlay)
                    
                        selectedOverlay = stopOverlay
                    }
                    
                    else
                    {
                        selectedOverlay = nil
                    }
                    
                    mapView.setCenter(stopOverlay.coordinate, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let stop = stops[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShuttleViewStopCell", for: indexPath) as! ShuttleViewStopCell
        
        cell.stop = stop
        
        return cell
    }
    
    fileprivate func polyLineWithEncodedString(_ encodedString: String) -> MKPolyline {
        let bytes = (encodedString as NSString).utf8String
        let length = encodedString.lengthOfBytes(using: String.Encoding.utf8)
        var idx: Int = 0
        
        //var count = length / 4 //(original version)
        var count = length //(modified version)
        
        var coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: count)
        var coordIdx: Int = 0
        
        var latitude: Double = 0
        var longitude: Double = 0
        
        while (idx < length) {
            var byte = 0
            var res = 0
            var shift = 0
            
            repeat {
                byte = bytes![idx] - Int8(0x3F)
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            
            let deltaLat = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            latitude += Double(deltaLat)
            
            shift = 0
            res = 0
            
            repeat {
                byte = bytes![idx] - Int8(0x3F)
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
                coords.deallocate(capacity: count)
                coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: newCount)
                for index in 0..<count {
                    coords[index] = temp[index]
                }
                temp.deinitialize()
                count = newCount
            }
            
        }
        
        let polyLine = MKPolyline(coordinates: coords, count: coordIdx)
        coords.deinitialize()
        
        return polyLine
    }
    
    fileprivate func colorFromString(_ string: String) -> UIColor?
    {
        if string.characters.count != 6
        {
            return nil
        }
        
        let rString = string.substring(with: string.startIndex..<string.characters.index(string.startIndex, offsetBy: 1))
        let gString = string.substring(with: string.characters.index(string.startIndex, offsetBy: 2)..<string.characters.index(string.startIndex, offsetBy: 3))
        let bString = string.substring(with: string.characters.index(string.startIndex, offsetBy: 4)..<string.characters.index(string.startIndex, offsetBy: 5))
        
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
