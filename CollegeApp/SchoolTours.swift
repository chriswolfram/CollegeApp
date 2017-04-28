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
    static let tourURL = URL(string: "https://www.wolframcloud.com/objects/3696b94f-7229-4e8f-81a4-901aac909dd0"/*"https://www.wolframcloud.com/objects/a1a32f02-0959-4b46-9168-7a27046f9de6"*/)!
    
    static var tours = [Tour]()
    static var tourLandmarks = [TourLandmark]()
    
    static func refreshToursIfNeeded(_ callback: ((Bool)->Void)? = nil)
    {
        if tours.isEmpty || tourLandmarks.isEmpty
        {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                if let parser = XMLParser(contentsOf: School.tourURL)
                {
                    let xmlElement = XMLElement(parser: parser)
                    xmlElement.parse()
                    
                    //Get landmarks
                    if let landmarks = xmlElement["landmarks"]?["landmark", .all]?.flatMap({TourLandmark(xmlElement: $0)})
                    {
                        DispatchQueue.main.async
                        {
                            School.tourLandmarks = landmarks
                        }
                        
                        //Get tours
                        if let tours = xmlElement["tours"]?["tour", .all]?.flatMap({Tour(xmlElement: $0, landmarks: landmarks)})
                        {
                            DispatchQueue.main.async
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
