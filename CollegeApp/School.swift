//
//  School.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/12/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import Foundation
import MapKit

class School
{
    static let name = "Stanford"
    
    static let newsURL = NSURL(string: "https://news.stanford.edu/rss/index.xml")!
    static let eventsURL = NSURL(string: "http://events.stanford.edu/xml/rss.xml")!
    
    static let beaconUUID = NSUUID(UUIDString: "DE810A8D-5519-44BD-8767-BC24521E386D")!
    
    static let schoolRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.238, longitude: -71.1135), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.01))
    
    static let emergencyContacts =
    [
        (title: "Emergency", number: "911", formattedNumber: "911"),
        (title: "Anonymous Tip Line", number: "1-617-333-2159", formattedNumber: "+1 617-333-2159"),
        (title: "Closing Hotline", number: "1-617-333-2075", formattedNumber: "+1 617-333-2075"),
        (title: "Emergency Line", number: "1-617-333-2222", formattedNumber: "+1 617-333-2222"),
        (title: "Health Center", number: "1-617-333-2182", formattedNumber: "+1 617-333-2182"),
    ]
    
    static var landmarks: [Landmark]
    {
        return SchoolLandmarks.landmarks
    }
    
    //Events
    static var events: [Event]
    {
        return SchoolEvents.events
    }
    
    static func updateEvents()
    {
        SchoolEvents.updateEvents()
    }
    
    static var eventsDelegate: SchoolEventsDelegate?
    {
        set(newDelegate)
        {
            SchoolEvents.delegate = newDelegate
        }
        
        get
        {
            return SchoolEvents.delegate
        }
    }
    
    //News
    static var newsStories: [NewsStory]
    {
        return SchoolNews.newsStories
    }
    
    static func updateNewsStories()
    {
        SchoolNews.updateNewsStories()
    }
    
    static var newsDelegate: SchoolNewsDelegate?
    {
        set(newDelegate)
        {
            SchoolNews.delegate = newDelegate
        }
        
        get
        {
            return SchoolNews.delegate
        }
    }
}