//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, SchoolNewsDelegate
{
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 134.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        School.newsDelegate = self
        School.updateNewsStories()
        
        tableView.reloadData()
    }
    
    func schoolNewsDidLoadImage()
    {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.newsStories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell", forIndexPath: indexPath) as! NewsViewCell
        let news = School.newsStories[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        cell.thumbnailView.image = news.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let news = School.newsStories[indexPath.row]
        
        if news.link != nil
        {
            UIApplication.sharedApplication().openURL(news.link!)
        }
        
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
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
