//
//  RSSReader.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 12/30/15.
//  Copyright © 2015 Zalto Technologies. All rights reserved.
//

import Foundation
import UIKit

class RSSReader: NSObject, NSXMLParserDelegate
{
    var url: NSURL!
    var fullData = [(title: String, description: String, link: NSURL, imageURL: NSURL?, image: UIImage?)]()
    var delegate: RSSReaderDelegate?
    
    private var xmlParser: NSXMLParser!
    
    //Parsing state information
    private var entry: (title: String?, description: String?, link: NSURL?, imageURL: NSURL?) = (title: nil, description: nil, link: nil, imageURL: nil)
    private var currentTag = ""
    private var currentValue = ""
    
    required init(url: NSURL)
    {
        self.url = url
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        //May be destructive
        currentValue += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
        
        //print(entry.link)
        if elementName == "item" && entry.title != nil && entry.description != nil && entry.link != nil
        {
            let dataEntry = (title: entry.title!, description: entry.description!, link: entry.link!, imageURL: entry.imageURL, image: nil as UIImage?)
            fullData.append(dataEntry)
        }

        currentValue = ""
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
                                self.delegate?.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        self.delegate?.reloadData()
    }
    
    func refresh()
    {
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        
        fullData = []
        xmlParser.parse()
        
        self.delegate?.reloadData()
    }
}

protocol RSSReaderDelegate
{
    func reloadData()
}