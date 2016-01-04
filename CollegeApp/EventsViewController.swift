//
//  EventsView.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/30/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController
{
    let rssURLString = "http://events.stanford.edu/xml/rss.xml"
    
    var xmlRoot: XMLElement!
    var rssRoot: XMLElement!
    var events = [Event]()
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 143.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Configure RSS feed reader
        let parser = NSXMLParser(contentsOfURL: NSURL(string: rssURLString)!)
        xmlRoot = XMLElement(parser: parser!)
        xmlRoot.parse()
        
        //TODO: add error checking
        rssRoot = xmlRoot["rss"]!["channel"]!
        
        //Turn parsed RSS data into dictionaries
        events = rssRoot["item", .All]!.map
        {
            item in
            let event = Event()
            event.title = item["title"]?.contents
            
            if let urlString = item["link"]?.contents
            {
                event.link = NSURL(string: urlString)
            }
            
            if let urlString = item["enclosure"]?.attributes["url"]
            {
                event.imageURL = NSURL(string: urlString)
            }
            
            return event
        }
        
        events.forEach
        {
            event in
            event.loadImage
            {
                self.tableView.reloadData()
            }
        }
        
        tableView.reloadData()
    }
    
    func reloadData()
    {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsViewCell", forIndexPath: indexPath) as! EventsViewCell
        let event = events[indexPath.row]
        
        cell.titleLabel.text = event.title
        cell.imageView?.image = event.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let event = events[indexPath.row]
        
        //TODO: Maybe add popup if the link is broken
        if event.link != nil
        {
            UIApplication.sharedApplication().openURL(event.link!)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func refresh(sender: AnyObject)
    {
        self.viewDidAppear(false)
        
        self.refreshControl?.endRefreshing()
    }
}

class Event
{
    //var imageView: UIImageView?
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var link: NSURL?
    
    func loadImage(callback: ()->Void)
    {
        //imageView?.image = image
        
        if image == nil && imageURL != nil
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let imageData = NSData(contentsOfURL: self.imageURL!), let image = UIImage(data: imageData)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = image
                        callback()
                    }
                }
            }
        }
    }
}