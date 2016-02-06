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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        School.newsDelegate = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 134.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //If news stories haven't been loaded before, load them
        if School.newsStories.count == 0
        {
            School.updateNewsStories()
        }
        
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
        let story = School.newsStories[indexPath.row]
        
        var cellIdentifier: String!
        
        if story.image == nil
        {
            cellIdentifier = "NewsViewTextCell"
        }
        
        else if indexPath.row % 4 == 0
        {
            cellIdentifier = "NewsViewFeaturedCell"
        }
        
        else
        {
            cellIdentifier = "NewsViewRegularCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsViewCell
        
        cell.showNewsStory(story)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let story = School.newsStories[indexPath.row]
        
        if story.link != nil
        {
            UIApplication.sharedApplication().openURL(story.link!)
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
        School.updateNewsStories()

        self.refreshControl?.endRefreshing()
    }
}
