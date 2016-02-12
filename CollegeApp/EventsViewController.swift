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
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        //Show the add events button if it should
        if School.addEventsButton
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addEventsButtonPressed"))
        }
        
        School.eventsDelegate = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Load events
        if School.events.count == 0
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                School.updateEvents()
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func schoolEventsDidLoadImage()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.tableView.reloadData()
        }
    }
    
    func addEventsButtonPressed()
    {
        School.addEventsButtonPressed()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsViewCell", forIndexPath: indexPath) as! EventsViewCell
        let event = School.events[indexPath.row]
        
        cell.showEvent(event)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let event = School.events[indexPath.row]
        
        if event.link != nil
        {
            navigationController?.pushViewController(WebView(url: event.link!), animated: true)
        }
        
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func refresh(sender: AnyObject)
    {
        School.updateEvents()
        tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
}
