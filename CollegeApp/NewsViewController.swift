//
//  NewsViewController.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/19/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, NSXMLParserDelegate
{
    static let xmlURLString = "https://news.stanford.edu/rss/index.xml"
    
    var xmlParser: NSXMLParser!
    
    var fullData = [(title: String, description: String, link: NSURL, imageURL: NSURL?, image: UIImage?)]()
    
    //Parsing state information
    private var entry: (title: String?, description: String?, link: NSURL?, imageURL: NSURL?) = (title: nil, description: nil, link: nil, imageURL: nil)
    private var currentTag = ""
    private var currentValue = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Configure table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 143.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Configure parser
        let url = NSURL(string: NewsViewController.xmlURLString)!
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        currentValue = string
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentTag = elementName
        if elementName == "item"
        {
            entry = (title: nil, description: nil, link: nil, imageURL: nil)
        }
        
        else if(elementName == "enclosure")
        {
            if let urlString = attributeDict["url"]
            {
                entry.imageURL = NSURL(string: urlString)
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if currentTag == elementName
        {
            switch currentTag
            {
                case "title":
                    entry.title = currentValue
                case "description":
                    entry.description = currentValue
                case "link":
                    entry.link = NSURL(string: currentValue)
                default:
                    break
            }
        }
        
        if elementName == "item" && entry.title != nil && entry.description != nil && entry.link != nil
        {
            let dataEntry = (title: entry.title!, description: entry.description!, link: entry.link!, imageURL: entry.imageURL, image: nil as UIImage?)
            fullData.append(dataEntry)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        //Dispatch threads to get the thumbnails and send them to the table data (fullData)
        for (i, news) in fullData.enumerate()
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                //TODO: Use Swift 2.0 syntax
                if news.imageURL != nil
                {
                    if let imageData = NSData(contentsOfURL: news.imageURL!)
                    {
                        if let image = UIImage(data: imageData)
                        {
                            dispatch_async(dispatch_get_main_queue())
                            {
                                self.fullData[i].image = image
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fullData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell", forIndexPath: indexPath) as! NewsViewCell
        let news = fullData[indexPath.row]
        
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
        let news = fullData[indexPath.row]
        
        UIApplication.sharedApplication().openURL(news.link)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //Run if the refresh controller is triggered (slide down to refresh)
    @IBAction func refresh(sender: AnyObject)
    {
        let url = NSURL(string: NewsViewController.xmlURLString)!
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        
        fullData = []
        xmlParser.parse()
        
        self.refreshControl?.endRefreshing()
    }
}