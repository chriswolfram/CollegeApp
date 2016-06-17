//
//  SchoolTours.swift
//  CollegeApp
//
//  Created by Christopher Wolfram on 1/24/16.
//  Copyright © 2016 Zalto Technologies. All rights reserved.
//

import MapKit

extension School
{
    static let tourURL = NSURL(string: "https://www.wolframcloud.com/objects/3696b94f-7229-4e8f-81a4-901aac909dd0"/*"https://www.wolframcloud.com/objects/a1a32f02-0959-4b46-9168-7a27046f9de6"*/)!
    
    static var tours = [Tour]()
    static var tourLandmarks = [TourLandmark]()
    
    static func refreshToursIfNeeded(callback: (Bool->Void)? = nil)
    {
        if tours.isEmpty || tourLandmarks.isEmpty
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                if let parser = NSXMLParser(contentsOfURL: School.tourURL)
                {
                    let xmlElement = XMLElement(parser: parser)
                    xmlElement.parse()
                    
                    //Get landmarks
                    if let landmarks = xmlElement["landmarks"]?["landmark", .All]?.flatMap({TourLandmark(xmlElement: $0)})
                    {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            School.tourLandmarks = landmarks
                        }
                        
                        //Get tours
                        if let tours = xmlElement["tours"]?["tour", .All]?.flatMap({Tour(xmlElement: $0, landmarks: landmarks)})
                        {
                            dispatch_async(dispatch_get_main_queue())
                            {
                                School.tours = tours
                                callback?(true)
                            }
                        }
                        
                        else
                        {
                            callback?(false)
                        }
                    }
                    
                    else
                    {
                        callback?(false)
                    }
                }
                
                else
                {
                    callback?(false)
                }
            }
        }
        
        else
        {
            callback?(true)
        }
    }
}