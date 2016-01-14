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
        searchBar.placeholder = "Search Stanford"
        
        //Configure gesture recognizer to pick up taps to escape the search bar
        mapView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: Selector("mapTapped"))
        
        //Initialize resultsView
        resultsView.configure()
        resultsView.searchResultsDelegate = self
        resultsView.hidden = true
        
        //Configure map
        mapView.region = SchoolInfo.schoolRegion
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
    
    func showPins(locations: [NamedLocation])
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
    
    func mapSearchResultSelected(location: NamedLocation)
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
}