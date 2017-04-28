//
//  GalleryViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 2/25/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit
import WebKit

class GalleryViewController: UITableViewController
{
    let fyuseIdentifiers = ["372nsdz790", "3rofz4ixjt", "abbcj9dy5l", "7bw92gpkmr"]
    var fyuseViews = [FyuseViewController]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        fyuseViews = fyuseIdentifiers.map
        {
            let fyuseView = FyuseViewController()
            fyuseView.showFyuse($0)
            
            return fyuseView
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fyuseViews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryViewCell", for: indexPath) as! GalleryViewCell
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.showFyuse(fyuseViews[indexPath.row])
        
        return cell
    }
}
