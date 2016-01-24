//
//  SchoolNews.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

class SchoolNews
{
    static var newsStories = [NewsStory]()
    static var delegate: SchoolNewsDelegate?
    
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
            let news = NewsStory()
            news.title = item["title"]?.contents
        
            if let urlString = item["link"]?.contents
            {
                news.link = NSURL(string: urlString)
            }
        
            if let urlString = item["enclosure"]?.attributes["url"]
            {
                news.imageURL = NSURL(string: urlString)
            }
        
            if let descString = item["description"]?.contents
            {
                news.description = descString
            }
        
            return news
        }
    
        //Asynchronously get thumbnails
        newsStories.forEach
        {
            news in
            news.loadImage
            {
                delegate?.schoolNewsDidLoadImage()
            }
        }
    }
}

protocol SchoolNewsDelegate
{
    func schoolNewsDidLoadImage()
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
            }
        }
    }
}