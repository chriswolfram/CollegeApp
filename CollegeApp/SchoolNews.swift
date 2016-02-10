//
//  SchoolNews.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

extension School
{
    static let newsURL = NSURL(string: "https://news.stanford.edu/rss/index.xml")!
    
    static var newsStories = [NewsStory]()
    static var newsDelegate: SchoolNewsDelegate?
    
    private static var xmlRoot: XMLElement!
    private static var rssRoot: XMLElement!
    
    static func updateNewsStories()
    {
        //Configure RSS feed reader
        let parser = NSXMLParser(contentsOfURL: School.newsURL)
        xmlRoot = XMLElement(parser: parser!)
        xmlRoot.parse()
    
        //TODO: add error checking
        rssRoot = xmlRoot["channel"]!
    
        //Turn parsed RSS data into dictionaries
        newsStories = rssRoot["item", .All]!.map
        {
            item in
            let story = NewsStory()
            story.title = item["title"]?.contents
        
            if let urlString = item["link"]?.contents
            {
                story.link = NSURL(string: urlString)
            }
        
            if let urlString = item["enclosure"]?.attributes["url"]
            {
                story.imageURL = NSURL(string: urlString)
            }
        
            if let descString = item["description"]?.contents
            {
                story.description = descString
            }
        
            return story
        }
    
        //Asynchronously get thumbnails
        for (i, story) in newsStories.enumerate()
        {
            story.loadImage
            {
                newsDelegate?.schoolNewsDidLoadImage(i)
            }
        }
    }
}

protocol SchoolNewsDelegate
{
    func schoolNewsDidLoadImage(index: Int)
}

class NewsStory
{
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var description: String?
    var link: NSURL?
    
    func loadImage(callback: ()->Void)
    {
        if image == nil && imageURL != nil
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let imageData = NSData(contentsOfURL: self.imageURL!), let image = UIImage(data: imageData)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.image = image
                        callback()
                    }
                }
                
                else
                {
                    self.imageURL = nil
                    callback()
                }
            }
        }
    }
}