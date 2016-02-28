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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        //self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("GalleryViewCell", forIndexPath: indexPath) as! GalleryViewCell
        
        let webView = WKWebView()
        cell.mainView.addSubview(webView)
        //cell.contentView.addSubview(webView)
        
        /*webView.addConstraints([
            NSLayoutConstraint(item: cell.mainView, attribute: .Top, relatedBy: .Equal, toItem: webView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cell.mainView, attribute: .Bottom, relatedBy: .Equal, toItem: webView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cell.mainView, attribute: .Leading, relatedBy: .Equal, toItem: webView, attribute: .Leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cell.mainView, attribute: .Trailing, relatedBy: .Equal, toItem: webView, attribute: .Trailing, multiplier: 1, constant: 0)
            ])*/
        
        //webView.topAnchor.constraintEqualToAnchor(cell.mainView.topAnchor).active = true
        //webView.bottomAnchor.constraintEqualToAnchor(cell.mainView.bottomAnchor).active = true
        //webView.leadingAnchor.constraintEqualToAnchor(cell.mainView.leadingAnchor).active = true
        //webView.trailingAnchor.constraintEqualToAnchor(cell.mainView.trailingAnchor).active = true
        
        //cell.contentView.topAnchor.constraintEqualToAnchor(webView.topAnchor).active = true
        //cell.contentView.bottomAnchor.constraintEqualToAnchor(webView.bottomAnchor).active = true
        //cell.contentView.leadingAnchor.constraintEqualToAnchor(webView.leadingAnchor).active = true
        //cell.contentView.trailingAnchor.constraintEqualToAnchor(webView.trailingAnchor).active = true
        
        //webView.loadHTMLString("<!DOCTYPE html><html><head><title>Page Title</title></head><body><h1>My First Heading</h1><p>My first paragraph.</p></body></html>", baseURL: nil)
        
        webView.backgroundColor = UIColor.redColor()
        
        return cell
    }
}