//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, RSSReaderDelegate
{
    static let rssURLString = "https://news.stanford.edu/rss/index.xml"
    
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
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rssReader.fullData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell", forIndexPath: indexPath) as! NewsViewCell
        let news = rssReader.fullData[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        
        //If there is an image for this cell, show it
        if news.image != nil
        {
            cell.thumbnailView.image = news.image
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let news = rssReader.fullData[indexPath.row]
        
        UIApplication.sharedApplication().openURL(news.link)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func reloadData()
    {
        self.tableView.reloadData()
    }
    
    //Run if the refresh controller is triggered (slide down to refresh)
    @IBAction func refresh(sender: AnyObject)
    {
        rssReader.refresh()
        
        self.refreshControl?.endRefreshing()
    }
}