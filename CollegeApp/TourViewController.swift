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
    @IBOutlet weak var progressIndicator: UIProgressView!
    
    static var sharedInstance: TourViewController?
        
    var tour: Tour
    {
        return Tour.sharedInstance!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TourViewController.sharedInstance = self
        
        navigationItem.title = tour.title
        
        //Setup map view
        mapView.delegate = self
        mapView.setRegion(School.schoolRegion, animated: false)
        
        updateTourView(tour)
        
        //Setup Beacons
        if School.useBeaconsTours
        {
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate!)
            
            appDelegate.tourController = self
            appDelegate.beginBeaconSearching()
        }
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
    
    func updateTourView(tour: Tour)
    {
        //Update progress indicator
        progressIndicator.setProgress(Float(tour.currentIndex) / Float(tour.landmarks.count-1), animated: true)
        
        //Update map
        mapView.removeOverlays(mapView.overlays)
        
        var coords = tour.landmarks.map({$0.coordinate})
        mapView.addOverlay(MKPolyline(coordinates: &coords, count: tour.landmarks.count))
        mapView.addOverlay(MKCircle(centerCoordinate: tour.currentLandmark.coordinate, radius: 10))
    }
    
    func goToLandmarkAtIndex(index: Int)
    {
        tour.currentIndex = index
        
        updateTourView(tour)
        TourViewPageController.sharedInstance?.updateDetailView(tour)
    }
    
    func continueToNextLandmark()
    {
        goToLandmarkAtIndex((tour.currentIndex + 1) % tour.landmarks.count)
    }
    
    func didEnterRegion(beaconRegion: CLBeaconRegion)
    {
        for (i, landmark) in tour.landmarks.enumerate()
        {
            if landmark.major == beaconRegion.major && landmark.minor == beaconRegion.minor
            {
                //If any beacon is detected, set that to the current index (probably not permanent)
                goToLandmarkAtIndex(i)
                break
            }
        }
    }
    
    @IBAction func skipButton(sender: UIBarButtonItem)
    {
        continueToNextLandmark()
    }
}