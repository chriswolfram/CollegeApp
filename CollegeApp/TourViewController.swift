//
//  TourViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/18/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

class TourViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    var pageViewController: TourViewPageController!
    
    var tour: Tour
    {
        return Tour.sharedInstance!
    }
    
    static var sharedInstance: TourViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TourViewController.sharedInstance = self
        
        //Setup map view
        mapView.delegate = self
        mapView.setRegion(School.schoolRegion, animated: false)
        
        updateMap(tour)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
            renderer.lineWidth = 2.0
            return renderer
        }
            
        else if overlay is MKCircle
        {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.redColor()
            return renderer
        }
            
        else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func updateMap(tour: Tour)
    {
        mapView.removeOverlays(mapView.overlays)
        
        var coords = tour.landmarks.map({$0.coordinate})
        mapView.addOverlay(MKPolyline(coordinates: &coords, count: tour.landmarks.count))
        mapView.addOverlay(MKCircle(centerCoordinate: tour.currentLandmark.coordinate, radius: 10))
    }
}