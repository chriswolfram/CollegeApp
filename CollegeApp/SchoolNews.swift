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
    //static let newsURL = URL(string: "http://feeds.feedburner.com/HarvardGazetteOnline")!
    static let newsURL = URL(string: "https://news.stanford.edu/feed/")!
    
    static var newsStories = [NewsStory]()
    
    fileprivate static var xmlRoot: XMLElement!
    fileprivate static var rssRoot: XMLElement!
    
    static func updateNewsStories()
    {
        //Configure RSS feed reader
        if let parser = XMLParser(contentsOf: School.newsURL)
        {
            xmlRoot = XMLElement(parser: parser)
            xmlRoot.parse()
            
            newsStories = []
            
            if let rssRoot = xmlRoot["channel"]
            {
                //Turn parsed RSS data into dictionaries
                if let items = rssRoot["item", .all]
                {
                    newsStories = items.map
                    {
                        item in
                        let story = NewsStory()
                        story.title = item["title"]?.contents
                        
                        if let urlString = item["link"]?.contents
                        {
                            story.link = URL(string: urlString)
                        }
                        
                        if let urlString = item["enclosure"]?.attributes["url"]
                        {
                            story.imageURL = URL(string: urlString)
                        }
                        
                        if let descString = item["description"]?.contents
                        {
                            story.description = descString
                        }
                        
                        return story
                    }
                }
            }
        }
    
        //Asynchronously get thumbnails
        newsStories.forEach({$0.loadImage()})
    }
}
