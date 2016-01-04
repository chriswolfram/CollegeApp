//
//  EventsView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/30/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController, RSSReaderDelegate
{
    static let rssURLString = "http://events.stanford.edu/xml/rss.xml"
    
    let rssReader = RSSReader(url: NSURL(string: rssURLString)!)
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 143.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Configure RSS Reader
        rssReader.delegate = self
        rssReader.refresh()
        
        let xmlElement = XMLElement(url: NSURL(string: "http://events.stanford.edu/xml/rss.xml")!)
        xmlElement.run()
        
        print(xmlElement.children.count)
    }
    
    func reloadData()
    {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rssReader.fullData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsViewCell", forIndexPath: indexPath) as! EventsViewCell
        let event = rssReader.fullData[indexPath.row]
        
        cell.titleLabel.text = event.title
        //cell.descriptionLabel.text = news.description
        
        //If there is an image for this cell, show it
        if event.image != nil
        {
            cell.thumbnailView.image = event.image
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let event = rssReader.fullData[indexPath.row]
        
        UIApplication.sharedApplication().openURL(event.link)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func refresh(sender: AnyObject)
    {
        rssReader.refresh()
        
        self.refreshControl?.endRefreshing()
    }
}