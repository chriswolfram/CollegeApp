//
//  MapSearchResultsView.swift
//  testing
//
//  Created by Christopher Wolfram on 12/14/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import MapKit

class MapSearchResultsView: UITableView, UITableViewDataSource, UITableViewDelegate
{
    //let locations = [NamedLocation]()
    let locations = [NamedLocation(coordinate: CLLocationCoordinate2D(latitude: 32.3, longitude: 43.8), title: "random"), NamedLocation(coordinate: CLLocationCoordinate2D(latitude: 38, longitude: 43.8), title: "random you")]
    
    var results = [NamedLocation]()
    
    var searchResultsDelegate: MapSearchResultsViewDelegate?
    
    func configure()
    {
        self.delegate = self
        self.dataSource = self
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MapSearchResultsViewCell")
    }
    
    func search(query: String)
    {
        func matchCheck(location: NamedLocation) -> Bool
        {
            return location.title!.lowercaseString.containsString(query.lowercaseString)
        }
        
        results = locations.filter(matchCheck)
        
        self.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MapSearchResultsViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = results[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        searchResultsDelegate?.mapSearchResultSelected(results[indexPath.row])
    }
}


protocol MapSearchResultsViewDelegate
{
    func mapSearchResultSelected(_: NamedLocation)
}


class NamedLocation: NSObject, MKAnnotation
{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String)
    {
        self.coordinate = coordinate
        self.title = title
    }
}