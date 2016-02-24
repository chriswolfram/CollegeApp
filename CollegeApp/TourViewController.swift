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
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewParent: UIView!
    @IBOutlet weak var scrollViewParentHeightContraint: NSLayoutConstraint!
    
    var tour = School.tours[0]

    var initialScrollViewParentHeight: CGFloat!
    var detailViewMaximized = false
    var pagesAdded = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = tour.title
        
        //Setup map view
        mapView.delegate = self
        mapView.setRegion(School.schoolRegion, animated: false)
        
        //Setup scroll view
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        //Setup Beacons
        if School.useBeaconsTours
        {
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate!)
            
            appDelegate.tourController = self
            appDelegate.beginBeaconSearching()
        }
        
        //Add blur effect to detail view
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewParent.insertSubview(effectView, belowSubview: scrollView)
        effectView.leadingAnchor.constraintEqualToAnchor(scrollViewParent.leadingAnchor).active = true
        effectView.trailingAnchor.constraintEqualToAnchor(scrollViewParent.trailingAnchor).active = true
        effectView.topAnchor.constraintEqualToAnchor(scrollViewParent.topAnchor).active = true
        effectView.bottomAnchor.constraintEqualToAnchor(scrollViewParent.bottomAnchor).active = true
        
        //Add tap gesture recognizer
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "detailViewTapped"))
        
        refreshTourView()
    }
    
    //override func viewDidLayoutSubviews()
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Save the initial detail view height
        if initialScrollViewParentHeight == nil
        {
            initialScrollViewParentHeight = scrollViewParentHeightContraint.constant
        }
        
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(tour.landmarks.count), height: scrollView.frame.height)
        //Only add the pages as subviews to the scroll view if they have not already been added
        if !pagesAdded
        {
            scrollView.pagingEnabled = true
            scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(tour.landmarks.count), height: scrollView.frame.height)
            
            for i in 0...tour.landmarks.count-1
            {
                loadLandmarkToPage(i)
            }
            
            pagesAdded = true
        }
    }
    
    func loadLandmarkToPage(index: Int)
    {
        let viewController = TourViewDetailController.controllerForLandmark(tour.landmarks[index])
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(viewController.view)
    }
    
    func detailViewTapped()
    {
        if self.detailViewMaximized
        {
            self.scrollViewParentHeightContraint.constant = self.initialScrollViewParentHeight
        }
            
        else
        {
            self.scrollViewParentHeightContraint.constant = 0
        }
        
        UIView.animateWithDuration(0.3, animations: {self.view.layoutIfNeeded()})
        
        detailViewMaximized = !detailViewMaximized
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        if currentPage != tour.currentIndex
        {
            tour.currentIndex = currentPage
            refreshTourView()
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 0.7)
            renderer.lineWidth = 4.0
            return renderer
        }
        
        else if overlay is MKCircle
        {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 0.1612726024261845, green: 0.9598687724116884, blue: 0.47757686732280463, alpha: 0.7)
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
        
        var coords = tour.landmarks.map({$0.coordinate})
        mapView.addOverlay(MKPolyline(coordinates: &coords, count: tour.landmarks.count))
        mapView.addOverlay(MKCircle(centerCoordinate: tour.currentLandmark.coordinate, radius: 10))
    }
    
    func goToLandmarkAtIndex(index: Int)
    {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0), animated: true)
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
    
    @IBAction func mapModeChanged(segmentedControl: UISegmentedControl)
    {
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .SatelliteFlyover
        default:
            break
        }
    }
}