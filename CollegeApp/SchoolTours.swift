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
    static let tourURL = NSURL(string: "https://www.wolframcloud.com/objects/9a34fc7d-4e68-43c9-b5a2-09f30505b869")!
    
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