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
        newsStories.forEach({$0.loadImage()})
    }
}