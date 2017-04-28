//
//  TourViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/18/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

class TourViewController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var scrollView: TourViewScrollView!
    
    var locManager: CLLocationManager!
    
    static let detailViewTopSpace: CGFloat = 300
    
    var pagesAdded = false
    
    var detailViewControllers = [Int:TourViewDetailController]()
    
    var tour: Tour!
    {
        didSet(newTour)
        {
            loadViewIfNeeded()
            refreshTourView()
        }
    }
    
    static func tourViewControllerFromTour(_ tour: Tour) -> TourViewController
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TourViewController") as! TourViewController
        
        viewController.tour = tour
        
        return viewController
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Setup location manager
        locManager = LocationManager.sharedInstance
        locManager.delegate = self
        
        //Update to reflect authorization settings
        locManager.requestWhenInUseAuthorization()
        self.locationManager(locManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        
        //Setup map view
        mapView.delegate = self
        mapView.setRegion(School.schoolRegion, animated: false)
        
        //Setup scroll view
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
    }
    
    //override func viewDidLayoutSubviews()
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        scrollView.ignoredArea = TourViewController.detailViewTopSpace
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(tour.landmarks.count), height: scrollView.frame.height)
        
        //Only add the pages as subviews to the scroll view if they have not already been added
        if !pagesAdded
        {
            scrollView.isPagingEnabled = true
            scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(tour.landmarks.count), height: scrollView.frame.height)
            
            for i in 0...tour.landmarks.count-1
            {
                loadLandmarkToPage(i)
            }
            
            pagesAdded = true
        }
    }
    
    func loadLandmarkToPage(_ index: Int)
    {
        let viewController = TourViewDetailController.controllerForLandmark(tour.landmarks[index])
        viewController.parentTourViewController = self
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(viewController.view)
        
        detailViewControllers[index] = viewController
        
        viewController.scrollCallback =
        {
            innerScrollView in
            self.scrollView.ignoredArea = TourViewController.detailViewTopSpace - innerScrollView.contentOffset.y
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        if currentPage != tour.currentIndex
        {
            tour.currentIndex = currentPage
            refreshTourView()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 235/255, green: 0/255, blue: 34/255, alpha: 1)
            renderer.lineWidth = 4.0
            return renderer
        }
        
        else if overlay is MKCircle
        {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor(red: 235/255, green: 0/255, blue: 34/255, alpha: 1)
            return renderer
        }
        
        else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func refreshTourView()
    {
        //Update progress indicator
        progressIndicator.setProgress(Float(tour.currentIndex) / Float(tour.landmarks.count-1), animated: true)
        
        //Update map
        mapView.removeOverlays(mapView.overlays)
        
        var coords = tour.landmarks.map({$0.coordinate!})
        mapView.add(MKPolyline(coordinates: &coords, count: tour.landmarks.count))
        mapView.add(MKCircle(center: tour.currentLandmark.coordinate, radius: 50))
        
        if let detailViewController = detailViewControllers[tour.currentIndex]
        {
            detailViewController.scrollCallback?(detailViewController.scrollView)
        }
    }
    
    func goToLandmarkAtIndex(_ index: Int)
    {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0), animated: true)
    }
    
    @IBAction func mapModeChanged(_ segmentedControl: UISegmentedControl)
    {
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satelliteFlyover
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
            
        else
        {
            manager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
}
