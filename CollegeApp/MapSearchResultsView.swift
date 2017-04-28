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
        self.register(UITableViewCell.self, forCellReuseIdentifier: "MapSearchResultsViewCell")
    }
    
    func search(_ query: String)
    {
        func matchCheck(_ location: Landmark) -> Bool
        {
            return location.title!.lowercased().contains(query.lowercased())
        }
        
        results = locations.filter(matchCheck)
        
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapSearchResultsViewCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        searchResultsDelegate?.mapSearchResultSelected(results[indexPath.row])
    }
}


protocol MapSearchResultsViewDelegate
{
    func mapSearchResultSelected(_: Landmark)
}
