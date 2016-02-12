//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

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
        
        //Load news stories
        if School.newsStories.count == 0
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                School.updateNewsStories()
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func schoolNewsDidLoadImage(index: Int)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.newsStories.count
    }
    
    func cellTypeAtIndex(indexPath: NSIndexPath) -> String
    {
        let story = School.newsStories[indexPath.row]
        
        var cellIdentifier: String!
        
        if story.imageURL == nil
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
        
        return cellIdentifier
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let story = School.newsStories[indexPath.row]
        
        let cellIdentifier = cellTypeAtIndex(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsViewCell
        cell.showNewsStory(story)
        
        cell.updateConstraints()
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let story = School.newsStories[indexPath.row]
        
        if story.link != nil
        {
            navigationController?.pushViewController(WebView(url: story.link!), animated: true)
        }
        
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //Run if the refresh controller is triggered (slide down to refresh)
    @IBAction func refresh(sender: AnyObject)
    {
        School.updateNewsStories()
        tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
}
