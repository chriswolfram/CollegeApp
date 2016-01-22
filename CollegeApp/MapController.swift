//
//  ViewController.swift
//  testing
//
//  Created by Christopher Wolfram on 12/9/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MapSearchResultsViewDelegate
{
    @IBOutlet var mapView: MKMapView!
    
    var locManager: CLLocationManager!
    
    var searchBar = UISearchBar()
    var gestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet var resultsView: MapSearchResultsView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mapController = self
        locManager = appDelegate.locManager
        
        //Update to reflect authorization settings
        self.locationManager(locManager, didChangeAuthorizationStatus: CLLocationManager.authorizationStatus())
        
        //Add and configure search bar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.setShowsCancelButton(false, animated: false)
        
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.placeholder = "Search \(SchoolInfo.schoolName)"
        
        //Configure gesture recognizer to pick up taps to escape the search bar
        mapView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: Selector("mapTapped"))
        
        //Initialize resultsView
        resultsView.configure()
        resultsView.searchResultsDelegate = self
        resultsView.hidden = true
        
        //Setup notifications for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeShown:"), name: UIKeyboardWillShowNotification, object: nil)
        
        //Configure map
        mapView.setRegion(SchoolInfo.schoolRegion, animated: false)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //Show toolbar and add tracking toggle button
        super.viewWillAppear(animated);
        
        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        trackingButton.customView?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.toolbar.barTintColor = self.navigationController?.navigationBar.barTintColor
        
        self.navigationController?.visibleViewController?.setToolbarItems([trackingButton], animated: animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        //Hide toolbar
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse
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
    
    func showPins(locations: [Landmark])
    {
        mapView.removeAnnotations(mapView.annotations)
        //mapView.addAnnotations(locations)
        mapView.showAnnotations(locations, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        //If the search field is not blank
        if searchText != ""
        {
            //Update and display the result view
            resultsView.search(searchText)
            resultsView.reloadData()
            
            resultsView.hidden = false
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        //If the search field is blank
        else
        {
            //Hide the result view
            resultsView.hidden = true
            searchBar.setShowsCancelButton(false, animated: true)
            showPins([])
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        resultsView.hidden = true
        searchBar.resignFirstResponder()
        showPins(resultsView.results)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: searchBar.text!)
        showPins([])
    }
    
    func mapSearchResultSelected(location: Landmark)
    {
        resultsView.hidden = true
        searchBar.resignFirstResponder()
        mapView.centerCoordinate = location.coordinate
        showPins([location])
    }
    
    func mapTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    func keyboardWillBeShown(notification: NSNotification)
    {
        //Adjust the results view insets when the keyboard is up
        let keyboardHeight = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size.height
        resultsView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        resultsView.scrollIndicatorInsets = resultsView.contentInset
    }
}