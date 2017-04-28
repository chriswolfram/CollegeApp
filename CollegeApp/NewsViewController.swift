//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 134.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Load news stories
        if School.newsStories.count == 0
        {
            self.refreshControl?.beginRefreshing()
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                School.updateNewsStories()
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func schoolNewsDidLoadImage(_ index: Int)
    {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.newsStories.count
    }
    
    func cellTypeAtIndex(_ indexPath: IndexPath) -> String
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let story = School.newsStories[indexPath.row]
        
        let cellIdentifier = cellTypeAtIndex(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsViewCell
        cell.newsStory = story
                
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let story = School.newsStories[indexPath.row]
        
        if story.link != nil
        {
            navigationController?.pushViewController(WebView(url: story.link!), animated: true)
        }
        
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Run if the refresh controller is triggered (slide down to refresh)
    @IBAction func refresh(_ sender: AnyObject)
    {
        School.updateNewsStories()
        tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
}
