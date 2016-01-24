//
//  EventsView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/30/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController, SchoolEventsDelegate
{
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        School.eventsDelegate = self
        School.updateEvents()
        
        tableView.reloadData()
    }
    
    func schoolEventsDidLoadImage()
    {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsViewCell", forIndexPath: indexPath) as! EventsViewCell
        let event = School.events[indexPath.row]
        
        cell.titleLabel.text = event.title
        cell.locationLabel.text = event.location
        cell.dateLabel.text = event.date
        cell.thumbnailView.image = event.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let event = School.events[indexPath.row]
        
        if event.link != nil
        {
            UIApplication.sharedApplication().openURL(event.link!)
        }
        
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func refresh(sender: AnyObject)
    {
        self.viewDidAppear(false)
        
        self.refreshControl?.endRefreshing()
    }
}