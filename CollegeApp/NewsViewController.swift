//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController
{
    let rssURLString = "https://news.stanford.edu/rss/index.xml"
    
    var xmlRoot: XMLElement!
    var rssRoot: XMLElement!
    var newsStories = [NewsStory]()
    
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
        rssRoot = xmlRoot["channel"]!
        
        //Turn parsed RSS data into dictionaries
        newsStories = rssRoot["item", .All]!.map
        {
            item in
            let news = NewsStory()
            news.title = item["title"]?.contents
            
            if let urlString = item["link"]?.contents
            {
                news.link = NSURL(string: urlString)
            }
                
            if let urlString = item["enclosure"]?.attributes["url"]
            {
                news.imageURL = NSURL(string: urlString)
            }
                
            if let descString = item["description"]?.contents
            {
                news.description = descString
            }
                
            return news
        }
        
        //Asynchronously get thumbnails
        newsStories.forEach
            {
                news in
                news.loadImage
                {
                    self.tableView.reloadData()
                }
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newsStories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell", forIndexPath: indexPath) as! NewsViewCell
        let news = newsStories[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        cell.thumbnailView.image = news.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let news = newsStories[indexPath.row]
        
        //TODO: Maybe add popup if the link is broken
        if news.link != nil
        {
            UIApplication.sharedApplication().openURL(news.link!)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //Run if the refresh controller is triggered (slide down to refresh)
    @IBAction func refresh(sender: AnyObject)
    {
        self.viewDidAppear(false)
        
        self.refreshControl?.endRefreshing()
    }
}

class NewsStory
{
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var description: String?
    var link: NSURL?
    
    func loadImage(callback: ()->Void)
    {
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