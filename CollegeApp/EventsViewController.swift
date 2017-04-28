//
//  EventsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/13/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Show the add events button if it should
        if School.addEventsButton
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(EventsViewController.addEventsButtonPressed))
        }
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Load events
        if School.events.count == 0
        {
            self.refreshControl?.beginRefreshing()
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                School.updateEvents()
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func addEventsButtonPressed()
    {
        School.addEventsButtonPressed()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return School.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsViewCell", for: indexPath) as! EventsViewCell
        
        if(School.events.count < indexPath.row)
        {
            let event = School.events[indexPath.row]
            cell.event = event
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay tableViewCell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        (tableViewCell as! EventsViewCell).loadThumbnail()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let event = School.events[indexPath.row]
        
        if event.link != nil
        {
            navigationController?.pushViewController(WebView(url: event.link!), animated: true)
        }
            
        else
        {
            let alertController = UIAlertController(title: "Unable to Load Page", message: "The selected page could not be loaded.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl)
    {
        School.updateEvents()
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
}
