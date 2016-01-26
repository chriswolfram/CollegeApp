//
//  SchoolEvents.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import UIKit

extension School
{
    static var events = [Event]()
    static var eventsDelegate: SchoolEventsDelegate?
    
    private static var xmlRoot: XMLElement!
    private static var rssRoot: XMLElement!
    
    static func updateEvents()
    {
        //Configure RSS feed reader
        let parser = NSXMLParser(contentsOfURL: School.eventsURL)
        xmlRoot = XMLElement(parser: parser!)
        xmlRoot.parse()
        
        //TODO: add error checking
        rssRoot = xmlRoot["channel"]!
        
        //Turn parsed RSS data into dictionaries
        events = rssRoot["item", .All]!.map
        {
            item in
            let event = Event()
            event.title = item["title"]?.contents
                
            if let urlString = item["link"]?.contents
            {
                event.link = NSURL(string: urlString)
            }
                
            if let urlString = item["enclosure"]?.attributes["url"]
            {
                event.imageURL = NSURL(string: urlString)
            }
                
            if var descString = item["description"]?.contents
            {
                descString = "<list>"+descString+"</list>"
                if let data = descString.dataUsingEncoding(NSUTF8StringEncoding)
                {
                    let descParser = NSXMLParser(data: data)
                    let descRoot = XMLElement(parser: descParser)
                    descRoot.parse()
                        
                    let divs = descRoot["div", .All]
                        
                    func checkClass(div: XMLElement, targetClass: String) -> Bool
                    {
                        return div.attributes["class"] != nil && div.attributes["class"]! == targetClass
                    }
                        
                    event.date = divs?.filter({checkClass($0, targetClass: "stanford-events-date")}).first?.contents
                    event.location = divs?.filter({checkClass($0, targetClass: "stanford-events-location")}).first?.contents
                    event.description = divs?.filter({checkClass($0, targetClass: "stanford-events-description")}).first?.contents
                        
                    let datePrefix = "Date: "
                    if event.date != nil && event.date!.hasPrefix(datePrefix)
                    {
                        event.date?.removeRange(event.date!.startIndex...event.date!.startIndex.advancedBy(datePrefix.characters.count-1))
                    }
                        
                    let locationPrefix = "Location: "
                    if event.location != nil && event.location!.hasPrefix(locationPrefix)
                    {
                        event.location?.removeRange(event.location!.startIndex...event.location!.startIndex.advancedBy(locationPrefix.characters.count-1))
                    }
                }
            }
                
            return event
        }
        
        //Asynchronously get thumbnails
        events.forEach
        {
            event in
            event.loadImage
            {
                eventsDelegate?.schoolEventsDidLoadImage()
            }
        }
    }
}

protocol SchoolEventsDelegate
{
    func schoolEventsDidLoadImage()
}

class Event
{
    var image: UIImage?
    var imageURL: NSURL?
    var title: String?
    var link: NSURL?
    var date: String?
    var location: String?
    var description: String?
    
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