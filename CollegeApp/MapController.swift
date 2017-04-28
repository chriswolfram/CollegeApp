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
    
    var segmentedControl: UISegmentedControl!
    
    @IBOutlet var resultsView: MapSearchResultsView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locManager = LocationManager.sharedInstance
        locManager.delegate = self
        
        //Update to reflect authorization settings
        locManager.requestWhenInUseAuthorization()
        self.locationManager(locManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        
        //Add and configure search bar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.showsBookmarkButton = true
        
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Search \(School.name)"
        
        //Configure gesture recognizer to pick up taps to escape the search bar
        mapView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(MapController.mapTapped))
        
        //Initialize resultsView
        resultsView.configure()
        resultsView.searchResultsDelegate = self
        resultsView.isHidden = true
        
        //Setup notifications for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(MapController.keyboardWillBeShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Configure map
        mapView.setRegion(School.schoolRegion, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Show toolbar and add tracking toggle button and map vs satellite segmented controller
        super.viewWillAppear(animated);
        
        //Make tracking button
        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        trackingButton.customView?.tintColor = UIColor.white
        
        //Make segmented controller
        segmentedControl = UISegmentedControl(items: ["Map", "Satellite"])
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MapController.mapModeChanged), for: .valueChanged)
        let segmentedControlItem = UIBarButtonItem(customView: segmentedControl)
        
        //Add all to the toolbar
        self.navigationController?.visibleViewController?.setToolbarItems([trackingButton, segmentedControlItem], animated: animated)
        
        //Show the toolbar
        self.navigationController?.toolbar.barTintColor = self.navigationController?.navigationBar.barTintColor
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //Hide toolbar
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    func mapModeChanged()
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
    
    func showPins(_ locations: [Landmark])
    {
        mapView.removeAnnotations(mapView.annotations)
        //mapView.addAnnotations(locations)
        mapView.showAnnotations(locations, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //If the search field is not blank
        if searchText != ""
        {
            //Update and display the result view
            resultsView.search(searchText)
            resultsView.reloadData()
            
            resultsView.isHidden = false
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        //If the search field is blank
        else
        {
            //Hide the result view
            resultsView.isHidden = true
            searchBar.setShowsCancelButton(false, animated: true)
            showPins([])
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        resultsView.isHidden = true
        searchBar.resignFirstResponder()
        showPins(resultsView.results)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: searchBar.text!)
        showPins([])
    }
    
    func mapSearchResultSelected(_ location: Landmark)
    {
        resultsView.isHidden = true
        searchBar.resignFirstResponder()
        mapView.centerCoordinate = location.coordinate
        showPins([location])
    }
    
    func mapTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    func keyboardWillBeShown(_ notification: Notification)
    {
        //Adjust the results view insets when the keyboard is up
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size.height
        resultsView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        resultsView.scrollIndicatorInsets = resultsView.contentInset
    }
}
