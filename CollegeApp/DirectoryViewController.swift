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
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        //Setup tap to escape
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.enabled = false
        gestureRecognizer.addTarget(self, action: "tableTapped")
    }
    
    func tableTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("DirectoryViewCell", forIndexPath: indexPath) as! DirectoryViewCell
    
        cell.showDirectoryEntry(entries[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let popover = storyboard?.instantiateViewControllerWithIdentifier("DirectoryViewDetailController") as! DirectoryViewDetailController
    
        popover.showDirectoryEntry(entries[indexPath.row])
    
        navigationController?.pushViewController(popover, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        gestureRecognizer.enabled = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        gestureRecognizer.enabled = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
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
    
    func searchEntries(query: String) -> [DirectoryEntry]
    {
        return School.directoryEntries.filter
        {
            entry in
            
            entry.name.containsString(query) ||
            (entry.title != nil && entry.title!.containsString(query)) ||
            (entry.department != nil && entry.department!.containsString(query))
        }
    }
}