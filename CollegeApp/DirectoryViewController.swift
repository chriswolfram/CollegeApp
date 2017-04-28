//
//  DirectoryViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/16/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class DirectoryViewController: UITableViewController, UISearchBarDelegate
{
    var searchBar = UISearchBar()
    var gestureRecognizer = UITapGestureRecognizer()
    
    var entries = School.directoryEntries
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setup table view
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Setup search bar
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        //Setup tap to escape
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.isEnabled = false
        gestureRecognizer.addTarget(self, action: #selector(DirectoryViewController.tableTapped))
    }
    
    func tableTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryViewCell", for: indexPath) as! DirectoryViewCell
    
        cell.showDirectoryEntry(entries[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailViewController = DirectoryViewDetailController.controllerForDirectoryEntry(entries[indexPath.row])
    
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        gestureRecognizer.isEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        gestureRecognizer.isEnabled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == ""
        {
            self.entries = School.directoryEntries
        }
        
        else
        {
            self.entries = searchEntries(searchText)
        }
        
        self.tableView.reloadData()
    }
    
    func searchEntries(_ query: String) -> [DirectoryEntry]
    {
        return School.directoryEntries.filter
        {
            entry in
            
            entry.name.contains(query) ||
            (entry.title != nil && entry.title!.lowercased().contains(query.lowercased())) ||
            (entry.department != nil && entry.department!.lowercased().contains(query.lowercased()))
        }
    }
}
