//
//  TourViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/18/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

class TourViewController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var tour = Tour(landmarks: [SchoolInfo.landmarks[0], SchoolInfo.landmarks[10], SchoolInfo.landmarks[12], SchoolInfo.landmarks[1]])
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setup page control
        pageControl.numberOfPages = tour.landmarks.count
        pageControl.currentPage = tour.currentIndex
        
        //Setup scroll view
        scrollView.delegate = self
        
        //Setup map view
        mapView.delegate = self
        mapView.setRegion(SchoolInfo.schoolRegion, animated: false)
        
        showTour(tour)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
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
    
    func showTour(tour: Tour)
    {
        mapView.removeOverlays(mapView.overlays)
        
        var coords = tour.landmarks.map({$0.coordinate})
        mapView.addOverlay(MKPolyline(coordinates: &coords, count: tour.landmarks.count))
        mapView.addOverlay(MKCircle(centerCoordinate: tour.currentLandmark.coordinate, radius: 10))
    }
    
    func nextLandmark()
    {
        tour.currentIndex = (tour.currentIndex + 1) % tour.landmarks.count
        showTour(tour)
    }
    
    @IBAction func nextButton(sender: AnyObject)
    {
        nextLandmark()
    }
}

class Tour
{
    let landmarks: [Landmark]
    var currentIndex = 0
    
    var currentLandmark: Landmark
    {
        get
        {
            return landmarks[currentIndex]
        }
    }
    
    init(landmarks: [Landmark])
    {
        self.landmarks = landmarks
    }
}