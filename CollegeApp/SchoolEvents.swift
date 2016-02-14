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
    static let eventsURL = NSURL(string: "http://events.stanford.edu/xml/rss.xml")!
    static let eventsCalendarURL = NSURL(string: "http://events.stanford.edu/eventlist.ics")!
    
    static let addEventsButton = true
    static func addEventsButtonPressed()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://events.stanford.edu/eventadmin/")!)
    }
    
    static var events = [Event]()
    
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
                        
                    event.dateString = divs?.filter({checkClass($0, targetClass: "stanford-events-date")}).first?.contents
                    event.location = divs?.filter({checkClass($0, targetClass: "stanford-events-location")}).first?.contents
                    event.description = divs?.filter({checkClass($0, targetClass: "stanford-events-description")}).first?.contents
                    
                    let datePrefix = "Date: "
                    if event.dateString != nil && event.dateString!.hasPrefix(datePrefix)
                    {
                        event.dateString?.removeRange(event.dateString!.startIndex...event.dateString!.startIndex.advancedBy(datePrefix.characters.count-1))
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
        
        //Get start dates
        let calendarElement = CalendarElement(url: School.eventsCalendarURL)!
        
        //TODO: add error checking
        calendarElement[0]!["VEVENT", .All]!.forEach
        {
            calendarEvent in
            
            if let
                dateString = calendarEvent["DTSTART"]?.contents,
                date = dateFromCalendar(dateString),
                urlString = calendarEvent["URL"]?.contents
            {
                self.events.forEach
                {
                    event in
                    
                    if let
                        eventURLString = event.link?.absoluteString
                    where
                        eventURLString == urlString
                    {
                        event.startDate = date
                    }
                }
            }
        }
        
        //Asynchronously get thumbnails
        //events.forEach({$0.loadImage()})
    }
    
    private static func dateFromCalendar(string: String) -> NSDate?
    {
        let dateComponents = NSDateComponents()
        
        if let
            year = Int(string.substringToIndex(string.startIndex.advancedBy(4))),
            month = Int(string.substringWithRange(string.startIndex.advancedBy(4)...string.startIndex.advancedBy(5))),
            day = Int(string.substringWithRange(string.startIndex.advancedBy(6)...string.startIndex.advancedBy(7))),
            hour = Int(string.substringWithRange(string.startIndex.advancedBy(9)...string.startIndex.advancedBy(10))),
            minute = Int(string.substringWithRange(string.startIndex.advancedBy(11)...string.startIndex.advancedBy(12))),
            second = Int(string.substringWithRange(string.startIndex.advancedBy(13)...string.startIndex.advancedBy(14)))
        {
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = second
            
            dateComponents.timeZone = NSTimeZone(abbreviation: "UTC")
            
            return NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        }
        
        return nil
    }
}