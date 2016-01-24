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
    let locations = School.landmarks
    
    var results = [Landmark]()
    
    var searchResultsDelegate: MapSearchResultsViewDelegate?
    
    func configure()
    {
        self.delegate = self
        self.dataSource = self
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MapSearchResultsViewCell")
    }
    
    func search(query: String)
    {
        func matchCheck(location: Landmark) -> Bool
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
    func mapSearchResultSelected(_: Landmark)
}