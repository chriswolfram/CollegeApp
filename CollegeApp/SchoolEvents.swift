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
    static let eventsURL = URL(string: "http://events.stanford.edu/xml/rss.xml")!
    static let eventsCalendarURL = URL(string: "http://events.stanford.edu/eventlist.ics")!
    
    static let addEventsButton = true
    static func addEventsButtonPressed()
    {
        UIApplication.shared.openURL(URL(string: "https://events.stanford.edu/eventadmin/")!)
    }
    
    static var events = [Event]()
    
    fileprivate static var xmlRoot: XMLElement!
    fileprivate static var rssRoot: XMLElement!
    
    static func updateEvents()
    {
        //Configure RSS feed reader
        if let parser = XMLParser(contentsOf: School.eventsURL)
        {
            xmlRoot = XMLElement(parser: parser)
            xmlRoot.parse()
            
            events = []
            
            if let rssRoot = xmlRoot["channel"]
            {
                //Turn parsed RSS data into dictionaries
                if let items = rssRoot["item", .all]
                {
                    events = items.map
                    {
                        item in
                        let event = Event()
                        event.title = item["title"]?.contents
                        
                        if let urlString = item["link"]?.contents
                        {
                            event.link = URL(string: urlString)
                        }
                        
                        if let urlString = item["enclosure"]?.attributes["url"]
                        {
                            event.imageURL = URL(string: urlString)
                        }
                        
                        if var descString = item["description"]?.contents
                        {
                            descString = "<list>"+descString+"</list>"
                            if let data = descString.data(using: String.Encoding.utf8)
                            {
                                let descParser = XMLParser(data: data)
                                let descRoot = XMLElement(parser: descParser)
                                descRoot.parse()
                                
                                let divs = descRoot["div", .all]
                                
                                func checkClass(_ div: XMLElement, targetClass: String) -> Bool
                                {
                                    return div.attributes["class"] != nil && div.attributes["class"]! == targetClass
                                }
                                
                                event.dateString = divs?.filter({checkClass($0, targetClass: "stanford-events-date")}).first?.contents
                                event.location = divs?.filter({checkClass($0, targetClass: "stanford-events-location")}).first?.contents
                                event.description = divs?.filter({checkClass($0, targetClass: "stanford-events-description")}).first?.contents
                                
                                let datePrefix = "Date: "
                                if event.dateString != nil && event.dateString!.hasPrefix(datePrefix)
                                {
                                    event.dateString?.removeSubrange(event.dateString!.startIndex...event.dateString!.characters.index(event.dateString!.startIndex, offsetBy: datePrefix.characters.count-1))
                                }
                                
                                let locationPrefix = "Location: "
                                if event.location != nil && event.location!.hasPrefix(locationPrefix)
                                {
                                    event.location?.removeSubrange(event.location!.startIndex...event.location!.characters.index(event.location!.startIndex, offsetBy: locationPrefix.characters.count-1))
                                }
                            }
                        }
                        
                        return event
                    }
                }
            }
        }
        
        //Get start dates
        if
            let calendarElement = CalendarElement(url: School.eventsCalendarURL),
            let vevents = calendarElement[0]?["VEVENT", .all]
        {
            vevents.forEach
            {
            calendarEvent in
                    
            if let
                dateString = calendarEvent["DTSTART"]?.contents,
                let date = dateFromCalendar(dateString),
                let urlString = calendarEvent["URL"]?.contents
            {
                self.events.forEach
                    {
                        event in
                                
                        if let
                            eventURLString = event.link?.absoluteString,
                            eventURLString == urlString
                        {
                            event.startDate = date
                        }
                    }
                }
            }
        }
        
        //Asynchronously get thumbnails
        //events.forEach({$0.loadImage()})
    }
    
    fileprivate static func dateFromCalendar(_ string: String) -> Date?
    {
        var dateComponents = DateComponents()
        
        if let
            year = Int(string.substring(to: string.characters.index(string.startIndex, offsetBy: 4))),
            let month = Int(string.substring(with: string.characters.index(string.startIndex, offsetBy: 4)..<string.characters.index(string.startIndex, offsetBy: 5))),
            let day = Int(string.substring(with: string.characters.index(string.startIndex, offsetBy: 6)..<string.characters.index(string.startIndex, offsetBy: 7))),
            let hour = Int(string.substring(with: string.characters.index(string.startIndex, offsetBy: 9)..<string.characters.index(string.startIndex, offsetBy: 10))),
            let minute = Int(string.substring(with: string.characters.index(string.startIndex, offsetBy: 11)..<string.characters.index(string.startIndex, offsetBy: 12))),
            let second = Int(string.substring(with: string.characters.index(string.startIndex, offsetBy: 13)..<string.characters.index(string.startIndex, offsetBy: 14)))
        {
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = second
            
            (dateComponents as NSDateComponents).timeZone = TimeZone(abbreviation: "UTC")
            
            return Calendar.current.date(from: dateComponents)
        }
        
        return nil
    }
}
